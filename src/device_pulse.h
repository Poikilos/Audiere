#ifndef DEVICE_PULSE_H
#define DEVICE_PULSE_H


#include "audiere.h"
#include "device_mixer.h"


namespace audiere {

  class PulseAudioDevice : public MixerDevice {
  public:
    static PulseAudioDevice* create(const ParameterList& parameters);

  private:
    PulseAudioDevice(int output_device);
    ~PulseAudioDevice();

  public:
    void ADR_CALL update();
    const char* ADR_CALL getName();

  private:
    int m_output_device;
  };

}


#endif
