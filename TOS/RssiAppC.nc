/*
 * Copyright (c) 2008 Dimas Abreu Dutra
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL DIMAS ABREU
 * DUTRA OR HIS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Dimas Abreu Dutra
 */
#include <Timer.h>
#include "RssiDemoMessages.h"
#include "StorageVolumes.h"

configuration RssiAppC {
} implementation {
  components ActiveMessageC, MainC, LedsC; 
  components SerialActiveMessageC;
   
  components new AMSenderC(AM_RSSIMSG) as RssiMsgSenderC;
  components new AMSenderC(AM_TRIGGERMSG) as TriggerMsgSenderC;
  components new TimerMilliC() as SendTimer;
  components new TimerMilliC() as InitSendTimer;
  components new TimerMilliC() as EndTimer;
  
  components new AMReceiverC(AM_RSSIMSG) as RssiMsgReceiverC;
  components new AMReceiverC(AM_TRIGGERMSG) as TriggerMsgReceiverC;
  
  components new SerialAMSenderC(AM_RSSIMSG) as SerialRssiMsgC;


  components new SerialAMReceiverC(AM_TRIGGERMSG) as SerialTriggerAMReceiverC;
  App.SerialTriggerReceive -> SerialTriggerAMReceiverC;

  components CC2420ActiveMessageC as RadioC;

  components new LogStorageC(VOLUME_LOGTEST, FALSE) as DataLogStorageC;
  
  components RssiC as App;

  App.Boot -> MainC;
  App.RadioControl -> ActiveMessageC;
  App.Leds-> LedsC;

  App.SendTimer -> SendTimer;
  App.InitSendTimer -> InitSendTimer;
  App.EndTimer -> EndTimer;

  App.RssiPacket-> RssiMsgSenderC;
  App.RssiAMPacket-> RssiMsgSenderC;  
  App.RssiMsgAMSend -> RssiMsgSenderC;
   
  App.TriggerPacket-> TriggerMsgSenderC;
  App.TriggerAMPacket-> TriggerMsgSenderC;
  App.TriggerMsgAMSend -> TriggerMsgSenderC;
  
  
  App.RssiMsgReceive->RssiMsgReceiverC;
  App.TriggerMsgReceive->TriggerMsgReceiverC;
  
  App.SerialAMControl-> SerialActiveMessageC;
  App.SerialDataLogAMSend-> SerialRssiMsgC;
  App.SerialDataLogPacket -> SerialRssiMsgC;
  App.SerialDataLogAMPacket-> SerialRssiMsgC;

  App.RadioPacket->RadioC.CC2420Packet;

  /*App.TriggerSend-> TriggerMsgSender;
  App.TriggerPacket -> TriggerMsgSender;
  App.TriggerAMPacket->TriggerMsgSender;*/

  App.DataLogRead -> DataLogStorageC.LogRead;
  App.DataLogWrite -> DataLogStorageC.LogWrite;
 
}
