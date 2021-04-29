/**
 * RESTFul CRUD for Settings
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="SettingService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "name";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Setting";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Display all non-site settings
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "name";
		param rc.search    = "";
		param rc.isCore = "";
		param rc.excludes = "siteSnapshot";

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			// Core filter if passed
			.when( len( rc.isCore ) && isBoolean( rc.isCore ), function( c ){
				c.isEq( "isCore", autoCast( "isCore", rc.isCore ) );
			} )
			.isNull( "site" );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

}
