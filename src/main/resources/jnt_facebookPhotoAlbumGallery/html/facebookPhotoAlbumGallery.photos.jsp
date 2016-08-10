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
<template:addResources type="css" resources="photoswipe/photoswipe.css" />
<template:addResources type="css" resources="photoswipe/default-skin/default-skin.css" />
<template:addResources type="javascript" resources="photoswipe/photoswipe.min.js"/>
<template:addResources type="javascript" resources="photoswipe/photoswipe-ui-default.min.js"/>
<template:addResources type="css" resources="bootstrap.min.css" />
<template:addResources type="css" resources="facebookfeed.css" />
<template:addResources type="javascript" resources="facebookfeed.js" />

<c:set var="siteNode" value="${renderContext.mainResource.node.resolveSite}"/>

<c:choose>
    <c:when test="${not empty param.albumId}">
        <c:set var="albumId" value="${param.albumId}"/>
    </c:when>
    <c:when test="${not empty param.albumId}">
        <c:set var="albumId" value="${currentResource.moduleParams.albumId}"/>
    </c:when>
    <c:otherwise>
        <c:set var="albumId" value=""/>
    </c:otherwise>
</c:choose>

<c:if test="${not empty albumId}">
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

    <jsp:setProperty name="facebookManager"
                     property="albumName"
                     value="${albumId}"/>

    <c:set var="photos" value="${facebookManager.photos}"/>
    <template:addResources>
      <script type="text/javascript">
        initializeFacebookGalleryPhotos = function () {
        	var _config = {
        		/* shared class used to activate all photoswipe enabled galleries */
        		photoswipeSelector: '.photoswipe-gallery${uuid}',
        		renderGallery: false,
        	};
        	return _config;
        };
        $(document).ready(function () {window._setGalleryComponentConfiguration.push(initializeFacebookGalleryPhotos);})
      </script>
    </template:addResources>

    <c:url var="albumDetailUrl" value="${url.base}${renderContext.mainResource.node.path}.html"/>
    <a href='${albumDetailUrl}'>
        <fmt:message key="jnt_backtoGallery"/>
    </a>
    <h1></h1>
    <c:url var="albumDetalUrl" value="${url.base}${currentNode.path}.photos.html"/>

    <div class='row photoswipe-gallery${uuid} media-gallery'>
        <c:forEach items="${photos}" var="photo">
            <figure class='col-md-4 col-lg-3 col-sm-6 col-xs-12'>
                <div class="image" src="${photo.url}" height="${photo.height}" width="${photo.width}" style="background-image: url('${photo.url}');"></div>
            </figure>
        </c:forEach>
    </div>

</c:if>