/*
 * Preprocessor Directives and Includes:
 *
 * This section is where all of the includes need to go, including but not
 * limited to:
 *
 * * S-Function header files.
 * * Finite State Machine header files?
 * <Required>
 */

/*END HEADERS*/

/* 
 * Section which defines the state machine class. If the state machine
 * cannot be included in the s-function, it must be defined here.
 */

/*END FSM*/

/*
 * Check Dialog Parameters:
 * 
 */
    /* Check Initial State*/

    /* Check Output Functions */

    /*Check that NSTs are valid*/

    /*Check that ANSTs are valid*/

    /*Check that ENSTs are valid*/

    /*END CHECK DIALOG PRMS*/

/*
 * Load Dialog Parameters
 * Check if the FSM is null.
 * If the FSM is not null, then re-load the parameters.
 */

    /* Load Initial State*/

    /* Load Output Functions */

    /* Load that NSTs are valid*/

    /* Load that ANSTs are valid*/

    /* Load that ENSTs are valid*/

/* END LOAD DIALOG PRMS*/

/*
 * Initial Sizes:
 * <Required>
 */

/*END INITIAL SIZES*/

/*
 * Initialize Sample Times:
 * <Required>
 */

/* END SAMPLE TIMES */

/* Start*/

/* Set pointer to an instantiation of the finite state machine.*/

/*END START*/

/*
 * Update:
 * This function will send a signal to the s-function, and it will carry
 * Out the necessary operations to check whether this can and will be done.
 */

/*END UPDATE*/

/* 
 * Outputs:
 * <Required>
 */

/*END OUTPUTS*/

/*
 * Terminate 
 */

/*END TERMINATE*/