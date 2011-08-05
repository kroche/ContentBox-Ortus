/**
* BlogBox UI module configuration
*/
component {
	
	// Module Properties
	this.title 				= "blogbox-ui";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "BlogBox UI Module";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// YOUR SES URL ENTRY POINT blog is a perfect example or empty if the Blog will be the main application
	this.entryPoint			= "blog";
	
	function configure(){
		
		// BB UI Module Conventions
		conventions = {
			layoutsLocation = "layouts",
			viewsLocation 	= "layouts"
		};

		// BLOGBOX MODULE LOCATION: CHANGE IF DIFFERENT FROM CONVENTIONS
		var BB_PATH = controller.getSetting("modules").blogbox.invocationPath;
		
		// BB UI SES Routing
		routes = [
			// home
			{pattern="/", handler="blog", action="index" },
			// preview
			{pattern="/__preview", handler="blog", action="preview" },
			// RSS feeds
			{pattern="/rss/category/:category", handler="blog", action="rss" },
			{pattern="/rss/comments/:entrySlug?", handler="blog", action="rss", commentRSS=true},
			{pattern="/rss/", handler="blog", action="rss" },
			// Comment post
			{pattern="/commentPost", handler="blog", action="commentPost" },
			// Blog index paging
			{pattern="/p/:page-numeric", handler="blog", action="index" },
			// category filter
			{pattern="/category/:category/:page-numeric?", handler="blog", action="index" },
			// search filter
			{pattern="/search/:q?/:page-numeric?", handler="blog", action="index" },
			// blog permalink
			{pattern="/:entrySlug", handler="blog", action="entry" }
			
		];		
		
		// BB UI Event driven programming extensions
		interceptorSettings = {
			// BlogBox UI Custom Events, you can add your own if you like to!
			customInterceptionPoints = arrayToList([
				// Layout HTML points: A layout must announce them via bb.event("bbui_footer",{renderer=this}) make sure you pass in the renderer
				"bbui_beforeHeadEnd","bbui_afterBodyStart","bbui_beforeBodyEnd","bbui_footer","bbui_beforeContent","bbui_afterContent","bbui_beforeSideBar","bbui_afterSideBar",
				// Code Interception points
				"bbui_onPageNotFound","bbui_onError","bbui_preRequest","bbui_postRequest","bbui_onRendererDecoration",
				// Fixed Handler Points
				"bbui_onIndex","bbui_onEntry","bbui_preCommentPost","bbui_onCommentPost",
				// Fixed HTML Points
				"bbui_preEntryDisplay","bbui_postEntryDisplay","bbui_preIndexDisplay","bbui_postIndexDisplay","bbui_preCommentForm","bbui_postCommentForm"
			])
		};
		
		// BB UI Interceptors
		interceptors = [
			// BB UI Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbUI" }
		];
		
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// TODO: Register currently selected layout's interception points
		
		// Treat the blog as the Main Application?
		if( !len(this.entryPoint) ){
			// generate the ses entry point
			var ses = controller.getInterceptorService().getInterceptor('SES',true);
			ses.addModuleRoutes(pattern="regex:.*",module="blogbox-ui");
			// change the default event
			controller.setSetting("DefaultEvent","blogbox-ui:blog");
		}
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// TODO: UnRegister currently selected layout's interception points
	}
	
}