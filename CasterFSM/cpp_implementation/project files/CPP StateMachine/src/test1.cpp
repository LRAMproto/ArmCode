#include <iostream>
#include "StateMachine.h"

#define s_stop 0
#define s_go 1
#define s_slow 2

#define i_change 0
#define i_err 1
#include <assert.h>
//#ifndef _POSIX_SOURCE
//#define _POSIX_SOURCE
//#endif



using namespace std; // cout, endl

int main(int argc, char **argv){
    StateMachine *stoplight = new StateMachine(s_go,1);
    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    // Adding regular transitions
    assert(stoplight->AddRegTransition(s_stop, i_change, s_go) == 0); // 0
    assert(stoplight->AddRegTransition(s_go, i_change, s_slow) == 0); // 1
    assert(stoplight->AddRegTransition(s_slow, i_change, s_stop) == 0); // 2
    // Adding an error transition
    assert(stoplight->AddErrTransition(i_err, s_stop)==0);
    assert(stoplight->SendInptSignal(i_err) == 0);

    assert(stoplight->GetcurrentState() == s_stop); //stoplight is at 0 now.

	assert(stoplight->FindErrTransition(i_err) == 0);
	assert(stoplight->FindErrTransition(i_change) == -1);

	assert(stoplight->FindAbsTransition(i_err) == -1);
	assert(stoplight->FindAbsTransition(i_change) == -1);

	assert(stoplight->FindRegTransition(stoplight->GetcurrentState(), i_err) == -1);
	assert(stoplight->FindRegTransition(stoplight->GetcurrentState(), i_change) == 0);

    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    stoplight->SendInptSignal(i_change);
    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;
    stoplight->SendInptSignal(i_change);
    cout << "The stoplight state machine is at state: " << stoplight->GetcurrentState() << endl;

    delete(stoplight);

}
