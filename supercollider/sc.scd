Exception.debug = false;
(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 32;
s.options.numInputBusChannels = 2;

// boot the server and start SuperDirt
s.waitForBoot {
    ~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
    ~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
    // for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
    //s.sync;
    ~dirt.start(57120, [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30]); // 16 stereo orbits (0-15)

    SynthDef(\heavycarrier, {
        |out, sus = 0.5, freq = 440, speed = 1, amp = 0.5, attack = 0.01, decay = 0.01, release = 0.1, gate = 1, pan, f1 = 1000, f2 = 1000|
        var syn, env, sound, form1, form2;
        env = EnvGen.ar(Env.adsr(attack: attack, decay: decay, sustain: sus, release: release), gate: gate);
        freq = freq * 0.25;
        syn = SinOsc.ar(freq: freq);
        syn = syn + Saw.ar(freq: freq, phase: 0, mul: 1, add: 0);
        //syn = syn + Pulse.ar(freq: freq*0.99, width: 0.5, mul: 1, add: 0);
        syn = syn + Saw.ar(freq: freq*1.01, phase: 0, mul: 1, add: 0);
        syn = syn + Saw.ar(freq: freq*1.02, phase: 0, mul: 1, add: 0);
        //syn = syn + Saw.ar(freq: freq*1.03, phase: 0, mul: 1, add: 0);
        syn = syn*env*amp*0.5;
        form1 = BPF.ar(syn, f1);
        form2 = BPF.ar(syn, f2);
        sound = form1 + form2;
        //sound = FreeVerb.ar(sound, 0.4, 0.99, 0.9);
        OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan));
    }).add;

    SynthDef(\lph, {
        |out, sus = 0.5, freq = 440, speed = 1, amp = 0.5, attack = 0.01 , decay = 0.01, release = 0.1, gate = 1, pan, f1 = 1000, f2 = 1000|
        var syn, env, sound, form1, form2;
        env = EnvGen.ar(Env.adsr(attack: attack, decay: decay, sustain: sus, release: release), gate: gate);
        freq = freq * 0.25;
        syn = Pulse.ar(freq*0.25);
        syn = syn + Saw.ar(freq*0.25);
        syn = syn*env*amp*0.5;
        form1 = BPF.ar(syn, f1);
        form2 = BPF.ar(syn, f2);
        sound = form1 + form2;
        //sound = FreeVerb.ar(sound, 0.4, 0.99, 0.9);
        OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan));
    }).add;


    SynthDef(\formantVoice, { arg
        out,
        freqs = #[ 400, 750, 2400, 2600, 2900 ],
        amps = #[ 1, 0.28, 0.08, 0.1, 0.01 ],
        qs = #[ 0.1, 0.1, 0.04, 0.04, 0.04 ],
        atk = 0.01,
        dec = 0.3,
        sus = 0.5,
        rel = 1.0,
        accelerate,
        accelerateTime = 1,
        f1 = 400,
        f2 = 750,
        f3 = 2400,
        f4 = 2600,
        f5 = 2900,
        a1 = 1,
        a2 = 0.28,
        a3 = 0.08,
        a4 = 0.1,
        a5 = 0.01,
        q1 = 0.1,
        q2 = 0.1,
        q3 = 0.04,
        q4 = 0.04,
        q5 = 0.04,
        lag = 0.5,
        vibratoSpeed = 6,
        vibratoDepth = 4,
        freq = 220,
        pan = 0.5,
        gain = 1.0,
        gate = 1,
        oscMix = 1;

        var vibrato, in, env, snd, freqsA, ampsA, qsA, basefreq;
        freqsA = Array.with(f1,f2,f3,f4,f5);
        ampsA = Array.with(a1,a2,a3,a4,a5);
        qsA = Array.with(q1,q2,q3,q4,q5);
        basefreq = freq + Line.kr(accelerate, 0, accelerateTime);
        vibrato = SinOsc.kr(vibratoSpeed, mul: vibratoDepth);
        in = Saw.ar(Lag.kr(basefreq + vibrato, 0.2));
        env = EnvGen.kr(Env.asr(atk, sus, rel), gate, doneAction: 2);
        snd = Mix.new(BBandPass.ar(
                in,
                Lag.kr(freqsA, lag),
                Lag.kr(qsA, lag)) * Lag.kr(ampsA, lag)).dup;
        Out.ar(out, DirtPan.ar(gain * snd * env, ~dirt.numChannels, pan));
    }).add;

    /*
    SynthDef(\wavtab, {
        |out, sustain = 0.5, freq = 440, speed = 1, amp = 1.0, attack = 0.01, decay = 0.01, release = 0.1, gate = 1, pan = 0.5, f1 = 11000, f2 = 11000, fmix = 0.0, b1 = 0, b2 = 0, b1off = 0.0, b2off = 0.0, bmix = 0.5|
        var sig1, sig2, sig, form1, form2, form, mix, env, normd;
        //env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate: gate);
        sig1 = Osc.ar(b1, freq);
        sig2 = Osc.ar(b2, freq);
        //sig = sig1*bmix + sig2*(1.0 - bmix);
        //form1 = BPF.ar(sig, f1);
        //form2 = BPF.ar(sig, f2);
        //form = form1 + form2;
        //mix = /*env * */(form * fmix + sig * (1.0 - fmix));
        //normd = Normalizer.ar(mix, 1.0, 0.01) * amp;
        normd = sig1 + sig2;
        OffsetOut.ar(out, DirtPan.ar(normd, ~dirt.numChannels, pan));
    }).add;
    */

    (
        MIDIClient.init;
        MIDIIn.connectAll;
        ~tidalSocket = NetAddr("127.0.0.1", 6010);
        ~notes=[];
        MIDIFunc.cc({|val, num, chan, src|
            ~tidalSocket.sendMsg('/ctrl', num, val/127.0);
            num.postln;val.postln;}, nil, nil, nil);
        MIDIFunc.noteOn({|veloc, num, chan, src|
            ~notes=~notes.add(num);
            ~notes=~notes.sort({|a,b| a>b}).reverse;
            ~tidalSocket.sendMsg('/ctrl', "notes", format("%", ~notes-60));
            ~notes.postln;});
        MIDIFunc.noteOff({|veloc, num, chan, src|
            ~notes=~notes.takeThese({|x| x==num});
            ~tidalSocket.sendMsg('/ctrl', "notes", format("%", ~notes-60));
            ~notes.postln;});

        ~midiOut = MIDIOut(0);
        ~midiOut.latency = 0;
        ~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
    );
};


s.latency = 0.5; // increase this if you get "late" messages
);
