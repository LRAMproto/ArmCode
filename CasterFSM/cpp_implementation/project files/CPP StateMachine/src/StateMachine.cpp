#include "StateMachine.h"
#include "Transition.h"
#include <vector>
#include <cstddef>
#include <iostream>
/*
 *
 */

StateMachine::StateMachine(int initState, int ignRptdInpts)
{
    this->initState = initState;
    this->currentState = initState;
    this->ignRptdInpts = ignRptdInpts;
    this->externalErrTransLoaded = 0;
    this->externalAbsTransLoaded = 0;
    this->externalRegTransLoaded = 0;
}

/* Transition container initializers. These functions
 * create a new container or return zero if a container already exists.
 * Params: None
 * Outputs: 0 upon successful initialization, -1 upon detecting error
 */

int StateMachine::initRegTransitions()
{
    if (regTransitions == NULL)
    {
        this->regTransitions = new std::vector<Transition>();
        if (this->regTransitions != NULL)
        {
            return 0;
        }
    }
    return -1;

}

int StateMachine::initErrTransitions()
{
    if (errTransitions == NULL)
    {
        this->errTransitions = new std::vector<Transition>();
        if (this->errTransitions != NULL)
        {
            return 0;
        }
    }
    return -1;
}

int StateMachine::initAbsTransitions()
{
    if (this->absTransitions == NULL)
    {
        this->absTransitions = new std::vector<Transition>();
        if (this->absTransitions != NULL)
        {
            return 0;
        }
    }
    return -1;
}

int StateMachine::AddRegTransition(int initState, int inpt, int finalState)
{
    this->initRegTransitions();
    Transition newTrans = Transition(initState, inpt, finalState);
    this->regTransitions->push_back(newTrans);
    return 0;
}

int StateMachine::AddErrTransition(int inpt, int finalState)
{
    this->initErrTransitions();
    //this->regTransitions->push_back(Transition(-1, inpt, finalState));
    Transition newTrans = Transition(-1, inpt, finalState);
    this->errTransitions->push_back(newTrans);
    return 0;
}

/* FINDERS:
 * Finds the appropriate transtition for the given input.
 */

int StateMachine::FindErrTransition(int inpt)
{
    int idx = -1;
    if (this->errTransitions != NULL)
    {
    	std::vector<Transition>::size_type i;
        for (i = 0; i != this->errTransitions->size(); i++)
        {
            if ((this->errTransitions->at(i)).Getinpt() == inpt)
            {
            	return i;
            }
        }
    }
    return idx;
}

int StateMachine::FindAbsTransition(int inpt)
{
    int idx = -1;
    if (this->absTransitions != NULL)
    {

    	std::vector<Transition>::size_type i;
        for(i = 0; i != this->absTransitions->size(); i++)
        {
            if ((this->absTransitions->at(i)).Getinpt() == inpt)
            {
            	return i;
            }
        }
    }
    return idx;
}

int StateMachine::FindRegTransition(int currentState, int inpt)
{
    int idx = -1;
    if (this->regTransitions != NULL)
    {
    	std::vector<Transition>::size_type i;
        for(i = 0; i != this->regTransitions->size(); i++)
        {
            if (
				((this->regTransitions->at(i)).Getinpt() == inpt)
									&&
				 ((this->regTransitions->at(i)).GetinitState() == this->currentState))

            {
            	return i;
            }
        }
    }
    return idx;
}

/*
* Sending an input to the state machine.
* Params: input (currently an integer);
* Output: success of signal handling.
*/

int StateMachine::SendInptSignal(int inpt)
{
    int transIdx = this->FindErrTransition(inpt);

    if (transIdx >= 0)
    {
        this->currentState = this->errTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }
    transIdx = this->FindAbsTransition(inpt);

    if (transIdx >= 0)
    {
        this->currentState = this->absTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }

    transIdx = this->FindRegTransition(this->currentState, inpt);
    if (transIdx >= 0)
    {
        this->currentState = this->regTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }

    return -1;
}

StateMachine::~StateMachine()
{
    if (this->externalErrTransLoaded == 0)
    {
        delete(this->errTransitions);
    }
    if (this->externalAbsTransLoaded == 0)
    {
        delete(this->absTransitions);
    }

    if (this->externalRegTransLoaded == 0)
    {
        delete(this->regTransitions);
    }

}
