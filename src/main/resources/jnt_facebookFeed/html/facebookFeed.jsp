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
<template:addResources type="css" resources="photoswipe/photoswipe.css"/>
<template:addResources type="css" resources="photoswipe/default-skin/default-skin.css"/>
<template:addResources type="javascript" resources="photoswipe/photoswipe.min.js"/>
<template:addResources type="javascript" resources="photoswipe/photoswipe-ui-default.min.js"/>
<template:addResources type="css" resources="bootstrap.min.css"/>
<template:addResources type="css" resources="facebookfeed.css"/>
<template:addResources type="javascript" resources="facebookfeed.js"/>

<c:set var="uuid" value="${currentNode.identifier}"/>
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="siteNode" value="${renderContext.mainResource.node.resolveSite}"/>
<div class="no-padding feed-component image-feed facebook">
<c:choose>
    <c:when test="${jcr:isNodeType(siteNode, 'jmix:facebookFeedConfiguration') and
    siteNode.properties['applicationId'] != null and
    siteNode.properties['applicationSecret'] != null}">
        <jsp:useBean id="facebookManager" class="org.jahia.modules.facebookfeed.FacebookFeedManager">
            <jsp:setProperty name="facebookManager"
                             property="facebookAppSecret"
                             value="${siteNode.properties['applicationSecret'].string}"/>
            <jsp:setProperty name="facebookManager"
                             property="facebookAppId"
                             value="${siteNode.properties['applicationId'].string}"/>

            <jsp:setProperty name="facebookManager"
                              property="pageName"
                              value="${ currentNode.properties['pageName'].string}"/>
            <jsp:setProperty name="facebookManager"
                              property="albumName"
                              value="${ currentNode.properties['albumName'].string}"/>
        </jsp:useBean>

        <c:set var="photos" value="${facebookManager.photos}"/>
        <c:choose>
            <c:when test="${not empty photos}">
                <template:addResources>
                    <script type="text/javascript">
                        initializeFacebookPhotos = function () {
                            var _config = {
                                /* shared class used to activate all photoswipe enabled galleries */
                                photoswipeSelector: '.photoswipe-gallery${uuid}',
                                renderGallery: true,
                                /* configuration for each gallery */
                                galleries: [
                                    {
                                        /* where each gallery will be injected*/
                                        domEntrypoint: '#custom-gallery${uuid}',
                                        /* default height and width to be used if one isn't provided per image configuration, REQUIRED */
                                        defaultHeight: '315',
                                        defaultWidth: '446',
                                        /* configuration per gallery */
                                        images: []
                                    }
                                ]
                            };
                            <c:forEach items="${photos}" var="photo" end="${currentNode.properties['maxEntries'].long - 1}">
                            _config.galleries[0].images.push({url: '${photo.url}', height: '${photo.height}', width: '${photo.width}'});
                            </c:forEach>
                            return _config;
                        };
                        window._setGalleryComponentConfiguration.push(initializeFacebookPhotos);
                    </script>
                </template:addResources>
            </c:when>
            <c:otherwise>
                <fmt:message key="label.cannot_retrieve_album"/>
            </c:otherwise>
        </c:choose>


            <c:if test="${not empty title}">
                <div class="headline">
                    <h2>${title}</h2>
                </div>
            </c:if>
            <div id="custom-gallery${uuid}" class="photoswipe-gallery${uuid}"></div>
            <div class="clearfix"></div>
            <div class="component-footer">
                <a href="http://www.facebook.com/${facebookManager.pageName}" class="footerlink" target="_blank"><fmt:message
                        key="jnt_checkOutFacebook"/></a>
            </div>
        </c:when>
        <c:otherwise>
            <fmt:message key="label.missing_app_id_secret"/>
        </c:otherwise>
</c:choose>
</div>
