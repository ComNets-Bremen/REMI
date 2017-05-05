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

#include "RssiDemoMessages.h"

module RssiC {
  uses interface Boot;
  uses interface Leds;
  
  uses interface Timer<TMilli> as SendTimer;
  uses interface Timer<TMilli> as InitSendTimer;
  uses interface Timer<TMilli> as EndTimer;
  
  uses interface Packet as RssiPacket;
  uses interface AMPacket as RssiAMPacket;
  uses interface AMSend as RssiMsgAMSend; 
  
  uses interface Packet as TriggerPacket;
  uses interface AMPacket as TriggerAMPacket;
  uses interface AMSend as TriggerMsgAMSend; 
  
  uses interface Receive as RssiMsgReceive;
  uses interface Receive as TriggerMsgReceive;
   
  uses interface SplitControl as RadioControl;
  
 
  uses interface SplitControl as SerialAMControl;
  uses interface AMSend as SerialDataLogAMSend;
  uses interface Packet as SerialDataLogPacket;
  uses interface AMPacket as SerialDataLogAMPacket;

  uses interface CC2420Packet as RadioPacket;

  uses interface LogRead as DataLogRead;
  uses interface LogWrite as DataLogWrite;

  uses interface Receive as SerialTriggerReceive;
} 

implementation {

  #include "log.h"
  message_t msg,msg1;
  //message_t uartMsg,triggerMsg;
  uint16_t seqNo;
//MAXSENDS,INIT_MAXSENDS;
  uint8_t next_node;
  int32_t suc1;
  uint16_t suc2;

  void sendRadioMsg()
  {
	RssiMsg_t* rmsg = (RssiMsg_t*)(call RssiPacket.getPayload(&msg, sizeof(RssiMsg_t)));
	rmsg->sender=TOS_NODE_ID;
        rmsg->seqNo = seqNo++;
	if(call RssiMsgAMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(RssiMsg_t))==SUCCESS)
        {
		suc1++;
	}

  }
  
  task void sendEndMsg()
  {
	next_node=TOS_NODE_ID++;
	if(next_node<=TOTAL_NODES)
	{	
		TriggerMsg_t* tmsg = (TriggerMsg_t*)(call TriggerPacket.getPayload(&msg1, sizeof(TriggerMsg_t)));
		tmsg->sendingnode = next_node;
		call TriggerMsgAMSend.send(AM_BROADCAST_ADDR, &msg1, sizeof(TriggerMsg_t));
	}
}
   
  
  event void Boot.booted(){
    /*=1000;
    INIT_MAXSENDS=MAXSENDS;*/
    seqNo=1;
    suc1=0;
    suc2=0;
    next_node=0;
    call RadioControl.start();
  }

  event void RadioControl.startDone(error_t result){
   if(result==SUCCESS)
   {
    	call Leds.led0Off();
	if(TOS_NODE_ID==1)
	{
		//start sending packet after 1 min F000, 15sec 3C00, 30sec 7800
		call InitSendTimer.startOneShot(0x7800);
	}
    }
    else
    {
	call Leds.led0On();
	call RadioControl.start();
  }
}

 event void InitSendTimer.fired(){
    call SendTimer.startPeriodic(SEND_INTERVAL_MS);

    //end timer will fire after 30 mins i.e exp time
     //call EndTimer.startOneShot(0x1C2000);
	// 15 min 0E1000
	// 1 min 0F000
     call EndTimer.startOneShot(0xE1000);
    }
 
  event void SendTimer.fired(){
    //call RssiMsgSend.send(AM_BROADCAST_ADDR, &msg, sizeof(RssiMsg)); 
    sendRadioMsg();   
  }
  
  event void EndTimer.fired(){
     call SendTimer.stop();
    // post sendOnUART();
	post sendEndMsg();
  }
  
   event void RssiMsgAMSend.sendDone(message_t *m, error_t error){
	RssiMsg_t logmsg;
	if(error==SUCCESS)
	{
		suc2++;
		logmsg.sender=TOS_NODE_ID;
       		logmsg.seqNo = seqNo;
		logmsg.rssi=suc1;
		logmsg.lqi=suc2;
		flexor_write_log(&logmsg);
        }
   }
  
   event void TriggerMsgAMSend.sendDone(message_t *m1, error_t error){
	
	if(error==SUCCESS)
	{
		call Leds.led1On();
        }
	else
	{
		next_node--;
		post sendEndMsg();
	}
   }
   
  event  message_t* RssiMsgReceive.receive(message_t* rssi_msg, void* payload, uint8_t len)
  {
		RssiMsg_t* rcvpkt = (RssiMsg_t*)payload;
		RssiMsg_t rcvmsg;
		if(len==sizeof(RssiMsg_t))
		{
			rcvmsg.sender = rcvpkt->sender;
			rcvmsg.seqNo = rcvpkt->seqNo;
			rcvmsg.rssi=call RadioPacket.getRssi(rssi_msg);
			rcvmsg.lqi= call RadioPacket.getLqi(rssi_msg);
			flexor_write_log(&rcvmsg);			
		}			
    		return rssi_msg;
 }

 event  message_t* TriggerMsgReceive.receive(message_t* trigger_msg, void* payload, uint8_t len)
  {
		TriggerMsg_t* rcvpkt = (TriggerMsg_t*)payload;
		
		if(len==sizeof(TriggerMsg_t*))
		{
			if(rcvpkt->sendingnode==TOS_NODE_ID)
			{
				//start sending packet after 1 min F000, 15sec 3C00, 30sec 7800
				call InitSendTimer.startOneShot(0x7800);	
			}			
		}			
    		return trigger_msg;
 }

  event  message_t* SerialTriggerReceive.receive(message_t* serialtrigger_msg, void* payload, uint8_t len)
  {
		TriggerMsg_t* rcvpkt = (TriggerMsg_t*)payload;
		
		if(len==sizeof(TriggerMsg_t*))
		{
			if(rcvpkt->sendingnode==1)
			{
				flexor_read_log();
			}			
			else if(rcvpkt->sendingnode==2)
			{
				flexor_erase_log();
			}
		}			
    		return serialtrigger_msg;
 }

 

   event void RadioControl.stopDone(error_t result){}
}
