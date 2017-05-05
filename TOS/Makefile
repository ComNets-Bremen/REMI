COMPONENT=RssiAppC
BUILD_EXTRA_DEPS += RssiMsg.class TriggerMsg.class
RssiMsg.class: RssiMsg.java
	javac RssiMsg.java

RssiMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=RssiMsg RssiDemoMessages.h RssiMsg -o $@

TriggerMsg.class: TriggerMsg.java
	javac TriggerMsg.java

TriggerMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=TriggerMsg RssiDemoMessages.h TriggerMsg -o $@

CFLAGS += $(INCLUDES)
#CFLAGS +=-DCC2420_DEF_RFPOWER=31
CFLAGS +=-DCC2420_DEF_RFPOWER=3


include $(MAKERULES)
