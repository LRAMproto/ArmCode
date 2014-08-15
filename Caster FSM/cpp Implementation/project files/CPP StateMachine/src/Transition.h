#ifndef TRANSITION_H
#define TRANSITION_H


class Transition
{
    public:
        Transition(int initState, int inpt, int nextState);
        virtual ~Transition();
        int GetinitState() {
	return initState; }
        void SetinitState(int val) {
	initState = val; }
        int Getinpt() {
	return inpt; }
        void Setinpt(int val) {
	inpt = val; }
        int GetnextState() {
	return nextState; }
        void SetnextState(int val) {
	nextState = val; }
    protected:
    private:
        int initState;
        int inpt;
        int nextState;
};

#endif // TRANSITION_H
