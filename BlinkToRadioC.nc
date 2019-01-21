#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
}
implementation {
  bool busy = FALSE;
  message_t pkt;
  uint16_t counter = 0;

 event void Boot.booted() {
   call AMControl.start();
 }

 event void Timer0.fired() {
   counter++;
   call Leds.set(counter);
   if (!busy) {
    BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (BlinkToRadioMsg)));
    btrpkt->nodeid = TOS_NODE_ID;
    btrpkt->counter = counter;
    if (call AMSend.send(2, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
      busy = TRUE;
    }
  }
 }
 
 event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }
 
  event void AMControl.stopDone(error_t err) {
  }
  
  event void AMSend.sendDone(message_t* msg, error_t error) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
  
}