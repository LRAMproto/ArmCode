#ifndef STATEMACHINE_H
#define STATEMACHINE_H
#include "Transition.h"
#include <vector>

class StateMachine
{
    public:
        StateMachine(int initState,int ignRptdInpts);
        virtual ~StateMachine();
        int GetinitState() { return initState; }
        void SetinitState(int val) { initState = val; }
        int GetcurrentState() { return currentState; }
        void SetcurrentState(int val) { currentState = val; }
        int GetignoreRepeatedInpts() { return ignRptdInpts; }
        void SetignoreRepeatedInpts(int val) { ignRptdInpts = val; }
        // containers for transitions
        std::vector<Transition>*  GeterrTransitions() { return errTransitions; }
        void SeterrTransitions(std::vector<Transition>*  val) { errTransitions = val; }
        std::vector<Transition>*  GetregTransitions() { return regTransitions; }
        void SetregTransitions(std::vector<Transition>*  val) { regTransitions = val; }
        std::vector<Transition>*  GetabsTransitions() { return absTransitions; }
        void SetabsTransitions(std::vector<Transition>*  val) { absTransitions = val; }
        //misc
        int GetlastInpt() { return lastInpt; }
        //void SetlastInpt(int val) { lastInpt = val; }
        void AddRegTransition(int initState, int inpt, int finalState);
        void AddErrTransition(int inpt, int finalState);
        int SendInptSignal(int inpt);
        int FindErrTransition(int inpt);
        int FindAbsTransition(int inpt);
        int FindRegTransition(int currentState, int inpt);

    protected:
    private:
        int initState;
        int currentState;
        int inTransition;
        int ignRptdInpts;
        std::vector<Transition>* errTransitions;
        std::vector<Transition>* regTransitions;
        std::vector<Transition>* absTransitions;
        int lastInpt;

        int initErrTransitions();
        int initRegTransitions();
        int initAbsTransitions();

};

#endif // STATEMACHINE_H
