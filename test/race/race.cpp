#include <assert.h>
#ifdef _WIN32
    #include <windows.h>

    void best_sleep(unsigned int milliseconds)
    {
        Sleep(milliseconds);
    }
#else
    #include <unistd.h>

    void best_sleep(unsigned int milliseconds) //if sleep, scons shows g++ error: error: ambiguating new declaration of ‘void sleep(unsigned int)’
    {
        usleep(milliseconds * 1000); // takes microseconds
    }
#endif
#include "audiere.h"
using namespace std;
using namespace audiere;


int main() {
    AudioDevicePtr device(OpenDevice());
    assert(device);

    std::vector<OutputStreamPtr> streams;
    while (true) {
        OutputStreamPtr sound = OpenSound(device, "data/laugh.wav");
        assert(sound);
        sound->play();
        streams.push_back(sound);
        if (streams.size() > 100) {
            streams.erase(streams.begin());
        }
        best_sleep(250);
    }
}
