# Formant Synthesis with TidalCycles and SuperCollider

used tools:
* TidalCycles 1.0.7 (https://tidalcycles.org/)
    * composition
    * live-coding
* Ardour 5.12.0 (https://ardour.org/)
    * mixing
    * plug-in host
* SuperCollider 3.10.0 (https://supercollider.github.io/)
    * audio synthesis
    * midi/osc communication
* Catia 0.9.0 (https://kxstudio.linuxaudio.org/Applications:Catia)
    * audio route patching
* Cadence 0.9.0 (https://kxstudio.linuxaudio.org/Applications:Cadence)
    * jackd setup and control
* Jack Audio Connection Kit 2 1.9.12 (http://www.jackaudio.org/)
    * audio driver interface

used plugins:
* Tal-Reverb-III (lv2) (https://github.com/DISTRHO/DISTRHO-Ports)
* Fast Lookahead limiter (ladspa) (https://github.com/swh/ladspa)
* a-High/Low Pass Filter (luaproc) (Ardour bundled)
* EQ10Q Stereo (lv2) (http://eq10q.sourceforge.net/eq/eq10qs)
* a-Compressor stereo (lv2) (Ardour bundled)
* a-Reverb (lv2) (Ardour bundled)
* a-Delay (lv2) (Ardour bundled)
* Stereo reverb (ladspa) (http://kokkinizita.linuxaudio.org/linuxaudio/downloads/g2reverb-0.7.1.tar.bz2)
* PitchedDelay (lv2) (https://github.com/lkjbdsp/lkjb-dc12)