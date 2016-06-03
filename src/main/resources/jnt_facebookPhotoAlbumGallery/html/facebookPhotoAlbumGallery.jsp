<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="bootstrap.min.css" />
<template:addResources type="css" resources="facebookfeed.css"/>

<c:set var="siteNode" value="${renderContext.mainResource.node.resolveSite}"/>
<c:set var="hideTimelinePhotos" value="${currentNode.properties['hideTimelinePhotos'].boolean}"/>
<c:set var="hideMobileUploads" value="${currentNode.properties['hideMobileUploads'].boolean}"/>
<c:set var="hideCoverPhotos" value="${currentNode.properties['hideCoverPhotos'].boolean}"/>
<c:choose>
    <c:when test="${jcr:isNodeType(siteNode, 'jmix:facebookFeedConfiguration') and
    siteNode.properties['applicationId'] != null and
    siteNode.properties['applicationSecret'] != null}">
        <c:choose>
            <c:when test="${not empty param.albumId}">
                <template:include view="photos">
                    <template:param name="albumId" value="${param.albumId}"/>
                </template:include>
            </c:when>
            <c:otherwise>
                <jsp:useBean id="facebookManager" class="org.jahia.modules.facebookfeed.FacebookFeedManager">
                    <c:if test="${jcr:isNodeType(siteNode, 'jmix:facebookFeedConfiguration')}">
                        <jsp:setProperty name="facebookManager"
                                         property="facebookAppSecret"
                                         value="${siteNode.properties['applicationSecret'].string}"/>
                        <jsp:setProperty name="facebookManager"
                                         property="facebookAppId"
                                         value="${siteNode.properties['applicationId'].string}"/>
                    </c:if>
                    <jsp:setProperty name="facebookManager"
                                     property="pageName"
                                     value="${ currentNode.properties['pageName'].string}"/>
                </jsp:useBean>

                <c:set var="albums" value="${facebookManager.albums}"/>
                <c:url var="albumDetailUrl" value="${url.base}${renderContext.mainResource.node.path}.html"/>

                <c:choose>
                    <c:when test="${not empty albums}">
                        <div class='row media-gallery'>
                            <c:forEach items="${albums}" var="album">
                                <c:choose>
                                    <c:when test="${((hideTimelinePhotos and (album.name eq 'Timeline Photos')) or (hideMobileUploads and (album.name eq 'Mobile Uploads')) or (hideCoverPhotos and (album.name eq 'Cover Photos')))}">
                                    <%-- Skip this album--%>
                                    </c:when>
                                    <c:otherwise>
                                <div class='col-md-3 col-sm-6 col-xs-12'>
                                    <a href='${albumDetailUrl}?albumId=${album.id}'>
                                        <div class="image" style="background-image:url('https://graph.facebook.com/${album.coverPhoto.id}/picture');"></div>
                                    </a>
                                    <h5 class="caption"><a href='${albumDetailUrl}?albumId=${album.id}'>${album.name}</a></h5>
                                </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="label.cannot_retrieve_page"/>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <fmt:message key="label.missing_app_id_secret"/>
    </c:otherwise>
</c:choose>

