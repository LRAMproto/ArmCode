#include <iostream>
#include "StateMachine.h"

#define s_stop 0
#define s_go 1
#define s_slow 2

#define i_change 0
#define i_err 1

using namespace std; // cout, endl

int main(int argc, char **argv){
    StateMachine *stoplight = new StateMachine(s_go,1);
    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    stoplight->AddRegTransition(s_stop, i_change, s_go);
    stoplight->AddRegTransition(s_go, i_change, s_slow);
    stoplight->AddRegTransition(s_slow, i_change, s_stop);
    stoplight->AddErrTransition(i_err, s_stop);
    stoplight->SendInptSignal(i_err);
	/*
	cout << stoplight->FindErrTransition(i_err) << endl;
	cout << stoplight->FindErrTransition(i_change) << endl;
	cout << stoplight->FindAbsTransition(i_err) << endl;
	cout << stoplight->FindAbsTransition(i_change) << endl;
	cout << stoplight->FindRegTransition(stoplight->GetcurrentState(), i_err) << endl;
	cout << stoplight->FindRegTransition(stoplight->GetcurrentState(), i_change) << endl;

    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    stoplight->SendInptSignal(i_change);
    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    */
    delete(stoplight);

}
