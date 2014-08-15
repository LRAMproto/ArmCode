#include "Transition.h"

Transition::Transition(int initState, int inpt, int nextState)
{
    this->initState = initState;
    this->inpt = inpt;
    this->nextState = nextState;
}

Transition::~Transition()
{
    //dtor
}
