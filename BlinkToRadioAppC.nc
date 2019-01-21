#include <Timer.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
 uses interface Packet;
 uses interface AMPacket;
 uses interface AMSend;
 uses interface SplitControl as AMControl;

}
implementation {
 components MainC;
 components LedsC;
 components BlinkToRadioC as App;
 components new TimerMilliC() as Timer0;
 components ActiveMessageC;
 components new AMSenderC(AM_BLINKTORADIO);

 App.Boot -> MainC;
 App.Leds -> LedsC;
 App.Timer0 -> Timer0;
 App.Packet -> AMSenderC;
 App.AMPacket -> AMSenderC;
 App.AMSend -> AMSenderC;
 App.AMControl -> ActiveMessageC;
}