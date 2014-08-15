#include "StateMachine.h"
#include "Transition.h"
#include <vector>
#include <cstddef>
#include <iostream>
StateMachine::StateMachine(int initState, int ignRptdInpts)
{
    this->initState = initState;
    this->currentState = initState;
    this->ignRptdInpts = ignRptdInpts;
}

int StateMachine::initRegTransitions()
{
    if (errTransitions == NULL)
    {
        this->regTransitions = new std::vector<Transition>();
        return 0;
    }
    return -1;

}

int StateMachine::initErrTransitions()
{
    if (errTransitions == NULL)
    {
        this->errTransitions = new std::vector<Transition>();
        return 0;
    }
    return -1;
}

int StateMachine::initAbsTransitions()
{
    if (errTransitions == NULL)
    {
        this->absTransitions = new std::vector<Transition>();
        return 0;
    }
    return -1;
}

void StateMachine::AddRegTransition(int initState, int inpt, int finalState)
{
    this->initRegTransitions();
    Transition newTrans = Transition(initState, inpt, finalState);
    this->regTransitions->push_back(newTrans);
}

void StateMachine::AddErrTransition(int inpt, int finalState)
{
    this->initErrTransitions();
    //this->regTransitions->push_back(Transition(-1, inpt, finalState));
    Transition newTrans = Transition(-1, inpt, finalState);
    this->errTransitions->push_back(newTrans);
}

int StateMachine::FindErrTransition(int inpt)
{
	int idx = -1;
    for(std::vector<Transition>::size_type i = 0; i != this->errTransitions->size(); i++)
    {
        if ((this->errTransitions->at(i)).Getinpt() == inpt)
        {
            idx = i;
            break;
        }
    }
    return idx;
}

int StateMachine::FindAbsTransition(int inpt)
{

    for(std::vector<Transition>::size_type i = 0; i != this->absTransitions->size(); i++)
    {
        if ((this->absTransitions->at(i)).Getinpt() == inpt)
        {
            return i;
        }
    }
    return -1;
}

int StateMachine::FindRegTransition(int currentState, int inpt)
{

    for(std::vector<Transition>::size_type i = 0; i != this->regTransitions->size(); i++)
    {
        if (((this->regTransitions->at(i)).Getinpt() == inpt) & ((this->regTransitions->at(i)).GetinitState() == currentState))
        {
            return i;
        }
    }
    return -1;
}


int StateMachine::SendInptSignal(int inpt)
{
    int transIdx = this->FindErrTransition(inpt);


    if (transIdx != -1)
    {
        this->currentState = this->errTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }
    transIdx = this->FindAbsTransition(inpt);

    if (transIdx != -1)
    {
        this->currentState = this->absTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }

    transIdx = this->FindRegTransition(this->currentState, inpt);
    if (transIdx != -1)
    {
        this->currentState = this->regTransitions->at(transIdx).GetnextState();
        this->lastInpt = inpt;
        return 0;

    }

    return -1;
}

StateMachine::~StateMachine()
{
    delete(this->absTransitions);
    delete(this->regTransitions);
    delete(this->errTransitions);
}
