
/* Is There an If */
/* May 13, 2020 */

/* This script generates electronics part of 'Is There an If?'. Electronics performer will trigger and control using midi controllers, Akai APC mini and Akai LPD 8. This piece will involve 8 speakers in which 2 will be placed beside the performers at the right and left of the stage (stereo L and R). A dynamic microphone, Shure SM58, will be placed in front of the flutist in order to pick up flute signal. */


//////////////////////////////////////// PREP ////////////////////////////////////////
/********* specify audio interface *********/
/********* change directory of prepared sound files *********/
/********* change channel/ ouput bus number in global variable *********/
/********* specify mic input channel in global variable *********/



// Note: cmd + shift + library to recompile class library, this will include reboot

(
{
	/* start up file */
	Server.local.options.numOutputBusChannels = 9; // change number of input and output channels
	Server.local.options.numInputBusChannels = 2;
	Server.internal.options.numOutputBusChannels = 9;
	Server.internal.options.numInputBusChannels = 2;
	//Server.local.options.device = "MOTU 896mk3 Hybrid";
	Server.local.options.inDevice = "Scarlett 2i4 USB"; // other possible audio interfaces
	//Server.local.options.outDevice = "Built-in Output";
	//Server.local.options.outDevice = "Orpheus (0979)";

	{s.meter;}.defer; // make sure number of channels is correct
	MIDIClient.init; // start midi
	MIDIIn.connectAll; // connect all midi devices

	s.waitForBoot { // go through becore booting server

		"buffers".postln;

		/* allocate buffers */
		~bufLength_rec1_2s = 2; // 2 second buffer
		~bufLength_rec2_2s = 2;
		~bufLength_rec3_2s = 2;
		~bufLength_rec1_3s = 3;
		~bufLength_rec1_4s = 4;
		~bufLength_rec2_4s = 4;
		~bufLength_rec3_4s = 4;
		~bufLength_rec4_4s = 4;
		~bufLength_rec5_4s = 4;
		~bufLength_rec6_4s = 4;
		~bufLength_rec1_5s = 5;
		~bufLength_rec2_5s = 5;
		~bufLength_rec3_5s = 5;
		~bufLength_rec4_5s = 5;
		~bufLength_rec5_5s = 5;
		~bufLength_rec6_5s = 5;
		~bufLength_rec1_8s = 8;
		~bufLength_rec2_8s = 8;
		~bufLength_rec1_17s = 17;
		~bufLength_rec1_22s = 22;


		~buf_rec1_2s = Buffer.alloc(s, 44100 * ~bufLength_rec1_2s, 1); // allocate buffer to record for 2 seconds
		s.sync;
		~buf_rec2_2s = Buffer.alloc(s, 44100 * ~bufLength_rec2_2s, 1);
		s.sync;
		~buf_rec3_2s = Buffer.alloc(s, 44100 * ~bufLength_rec3_2s, 1);
		s.sync;
		~buf_rec1_3s = Buffer.alloc(s, 44100 * ~bufLength_rec1_3s, 1);
		s.sync;
		~buf_rec1_4s = Buffer.alloc(s, 44100 * ~bufLength_rec1_4s, 1);
		s.sync;
		~buf_rec2_4s = Buffer.alloc(s, 44100 * ~bufLength_rec2_4s, 1);
		s.sync;
		~buf_rec3_4s = Buffer.alloc(s, 44100 * ~bufLength_rec3_4s, 1);
		s.sync;
		~buf_rec4_4s = Buffer.alloc(s, 44100 * ~bufLength_rec4_4s, 1);
		s.sync;
		~buf_rec5_4s = Buffer.alloc(s, 44100 * ~bufLength_rec5_4s, 1);
		s.sync;
		~buf_rec6_4s = Buffer.alloc(s, 44100 * ~bufLength_rec6_4s, 1);
		s.sync;
		~buf_rec1_5s = Buffer.alloc(s, 44100 * ~bufLength_rec1_5s, 1);
		s.sync;
		~buf_rec2_5s = Buffer.alloc(s, 44100 * ~bufLength_rec2_5s, 1);
		s.sync;
		~buf_rec3_5s = Buffer.alloc(s, 44100 * ~bufLength_rec3_5s, 1);
		s.sync;
		~buf_rec4_5s = Buffer.alloc(s, 44100 * ~bufLength_rec4_5s, 1);
		s.sync;
		~buf_rec5_5s = Buffer.alloc(s, 44100 * ~bufLength_rec5_5s, 1);
		s.sync;
		~buf_rec6_5s = Buffer.alloc(s, 44100 * ~bufLength_rec6_5s, 1);
		s.sync;
		~buf_rec1_8s = Buffer.alloc(s, 44100 * ~bufLength_rec1_8s, 1);
		s.sync;
		~buf_rec2_8s = Buffer.alloc(s, 44100 * ~bufLength_rec2_8s, 1);
		s.sync;
		~buf_rec1_17s = Buffer.alloc(s, 44100 * ~bufLength_rec1_17s, 1);
		s.sync;
		~buf_rec1_22s = Buffer.alloc(s, 44100 * ~bufLength_rec1_22s, 1);
		s.sync;
		~buf_rec_wind_low = Buffer.read(s, "/Users/shuyulin/Desktop/isThereAnIf/wind_low.wav");
		s.sync;
		~buf_rec_wind_high = Buffer.read(s, "/Users/shuyulin/Desktop/isThereAnIf/wind_high.wav");
		s.sync;
		~bufTestNoise = Buffer.read(s, "/Users/shuyulin/Desktop/isThereAnIf/test-noise.wav"); // noise for testing speakers
		s.sync;
		~bufTestSweep = Buffer.read(s, "/Users/shuyulin/Desktop/isThereAnIf/test-sweep.wav");
		s.sync;
		/*
		~bufStab = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // default sound file for testing
		s.sync;*/

		"buffers done".postln;




		////////////////////////////* function *////////////////////////////
		/* global variables for Motu setup */
		~ch0 = 0; // channel outputs
		~ch1 = 1;
		~ch2 = 2;
		~ch3 = 3;
		~ch4 = 4;
		~ch5 = 5;
		~ch6 = 6;
		~ch7 = 7;
		~ch8 = 8; // extra for expansion
		~ch_o = [0, 2, 4, 6];
		~ch_e = [1, 3, 5, 7];
		~ch_1_8 = [0, 1, 2, 3, 4, 5, 6, 7];
		~mic1 = 0; // mic input- flute
		~mic2 = 1; // extra for expansion

		/* pick up mic 1 signal, modify amplitude etc. for output */
		~inNdef1 = {
			Ndef.ar(\micIn1, 1); // 1 input from 1 mic
			//Ndef(\micIn, { Compander.ar(SoundIn.ar(2), 0, 0.7, 0.5, 0.9, 0.01, 0.1, 0.5) }); // with compressor
			Ndef(\micIn1, { SoundIn.ar(~mic1)}); // pick up from channel 0; this need to change based on tech setup
		}; // mic signal to channel 0
		~inNdef1.(); // run SoundIn ~inNdef globally


		/* function to record into buffer; record flute */
		SynthDef(\SoundIn, {
			arg bufnum = 0, recLevel = 1, preLevel = 0;
			var input, rec;
			input = SoundIn.ar(~mic1); // receive soprano signal and post signal info to make sure it is recording (.poll)
			rec = RecordBuf.ar(input, bufnum, 0, recLevel, preLevel, loop: 0, doneAction: 2);
		}).add;




		/***************** amplification functions *****************/
		/* function for amplify flute signal through speaker 1; button f1 */
		~amplifyFluteThru1 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch0], signal * vol);
		};

		/* function for amplify flute signal through speaker 2; button f2 */
		~amplifyFluteThru2 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch1], signal * vol);
		};

		/* function for amplify flute signal through speaker 3; button f3 */
		~amplifyFluteThru3 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch2], signal * vol);
		};

		/* function for amplify flute signal through speaker 4; button f4 */
		~amplifyFluteThru4 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch3], signal * vol);
		};

		/* function for amplify flute signal through speaker 5; button f5 */
		~amplifyFluteThru5 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch4], signal * vol);
		};

		/* function for amplify flute signal through speaker 6; button f6 */
		~amplifyFluteThru6 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch5], signal * vol);
		};

		/* function for amplify flute signal through speaker 7; button f7 */
		~amplifyFluteThru7 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch6], signal * vol);
		};

		/* function for amplify flute signal through speaker 8; button f8 */
		~amplifyFluteThru8 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar([~ch7], signal * vol);
		};

		/* function for amplify flute signal through speaker 1357; button f_o */
		~amplifyFluteThru_o = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar(~ch_o, signal * vol);
		};

		/* function for amplify flute signal through speaker 2468; button f_e */
		~amplifyFluteThru_e = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar(~ch_e, signal * vol);
		};

		/* function for amplify flute signal through speaker 12345678; button f_1_8 */
		~amplifyFluteThru_1_8 = {
			arg out, gate = 1, vol = 1, mix = 0, room = 0; // mix: dry/wet balance, range 0-1 (K3); room: room size, range 0-1 (K4); damp: Reverb HF damp, range 0-1;
			var in, amp, signal, env, damp = 0.5, mul = 1; // damp and mul are for reverb
			env = EnvGen.kr(Env.cutoff(0.5), gate, doneAction: 2);
			amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			//signal = (FreeVerb.ar(FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul), 0.3, 0.5, 1, 1) * amp * env);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul) * amp * env;
			Out.ar(~ch_1_8, signal * vol);
		};

		/* function for amplify flute signal through speaker 1, LPD K1 control panning of flute signal; button f1_p */
		~amplifyFluteThru1_p = {
			arg pos = 0, level = 0.2, vol = 0.8, mix = 0, room = 0;
			var in, signal, damp = 0.5, mul = 1;
			in = SoundIn.ar(~mic1);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);

			PanAz.ar(
				8, // numChans
				//SoundIn.ar(~mic1), // in
				//Ndef.ar(\micIn1, 1), // alternate way of input
				signal,
				pos,
				level,
				2, // width
				0, //orientation
			) * vol;
		};

		/* function for 12 seconds delay on input 0 */
		~delay12sec_input0 = {
			arg vol = 0.9;
			var in, signal, amp = 0.9;
			in = Ndef.ar(\micIn1, 1); // pick up from mic 1
			signal = AllpassN.ar(in, 0.2, 0.1, 12, 1) * amp;
			Out.ar(~ch_1_8, signal * vol);
		};


		/***************** playback functions *****************/
		/* playback live recordings with reverb and pan */

		/* playback rec1_2s with reverb and panning controls */
		~playback_rec1_2s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec2_2s with reverb and panning controls */
		~playback_rec2_2s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec1_3s_b with reverb and panning controls */
		~playback_rec1_3s_b = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0, rate = -1;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			//in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, startPos: BufFrames.kr(bufnum), doneAction: 0);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec1_5s with reverb and panning controls */
		~playback_rec1_5s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec2_5s with reverb and panning controls */
		~playback_rec2_5s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec3_5s with reverb and panning controls */
		~playback_rec3_5s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec1_17s with reverb and panning controls */
		~playback_rec1_17s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec2_4s with reverb and panning controls */
		~playback_rec2_4s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec3_4s with reverb and panning controls */
		~playback_rec3_4s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec4_4s with reverb and panning controls */
		~playback_rec4_4s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec5_4s with reverb and panning controls */
		~playback_rec5_4s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec1_22s_b with reverb and panning controls */
		~playback_rec1_22s_b = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0, rate = -1;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, startPos: BufFrames.kr(bufnum), doneAction: 0);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback rec6_5s with reverb and panning controls */
		~playback_rec6_5s = {
			arg bufnum, amp = 0.9, pos = 0, level = 0.2, mix = 0, room = 0;
			var in, signal, signalPan, signalPan1, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan1 = PanAz.ar(8, signal, pos, orientation:0);
			signalPan = signalPan1;
			Out.ar([0], signalPan * amp);
		};

		/* playback wind_low recording through speakers 1 3 5 7; button 1*/
		~playback_rec_wind_low_1357 = {
			arg bufnum, amp = 1, panPos = 0, level = 0.2, vol = 0.9, mix = 0, room = 0;
			var in, signal, signalPan, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan = PanAz.ar(8, signal, panPos, orientation:0);
			Out.ar(~ch_o, signalPan * vol);
		};

		/* playback wind_low recording through speakers 2 4 6 8; button 2*/
		~playback_rec_wind_low_2468 = {
			arg bufnum, amp = 1, panPos = 0, level = 0.2, vol = 0.9, mix = 0, room = 0;
			var in, signal, signalPan, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan = PanAz.ar(8, signal, panPos, orientation:0);
			Out.ar(~ch_e, signalPan * vol);
		};

		/* playback wind_low recording through speakers 2 4 6 8; button 2*/
		~playback_rec_wind_high_1357 = {
			arg bufnum, amp = 1, panPos = 0, level = 0.2, vol = 0.9, mix = 0, room = 0;
			var in, signal, signalPan, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan = PanAz.ar(8, signal, panPos, orientation:0);
			Out.ar(~ch_o, signalPan * vol);
		};

		/* playback wind_low recording through speakers 2 4 6 8; button 2*/
		~playback_rec_wind_high_2468 = {
			arg bufnum, amp = 1, panPos = 0, level = 0.2, vol = 0.9, mix = 0, room = 0;
			var in, signal, signalPan, damp = 0.5, mul = 1;
			in = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2);
			signal = FreeVerb.ar(Resonz.ar(in, 440, 1, 0.8), mix, room, damp, mul);
			signalPan = PanAz.ar(8, signal, panPos, orientation:0);
			Out.ar(~ch_e, signalPan * vol);
		};


		/***************** granular synth functions *****************/

		/* function for granularize rec1_17s */
		~gran_rec1_17s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning; don't put PanAz here because this is not the global pan
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0); // PanAz need to be put at the last to pan globally
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec4_5s */
		~gran_rec4_5s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec5_5s */
		~gran_rec5_5s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec1_4s */
		~gran_rec1_4s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec1_22s */
		~gran_rec1_22s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec3_2s */
		~gran_rec3_2s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec6_4s */
		~gran_rec6_4s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec1_8s */
		~gran_rec1_8s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize rec2_8s */
		~gran_rec2_8s = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, rate, minRate = 1, maxRate = 1.3, pos, interp, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 10;
			var env, signal, signalPan, signalPan1, signalPan2, signalPan3;
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			rate = LFNoise1.kr.range(minRate, maxRate); // frequency/ modulation
			pos = SinOsc.ar(LFNoise1.kr(200));
			interp = 2;
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainBuf.ar(numChannels, trigger, dur, sndbuf, rate, pos, interp, pan, envbufnum, maxGrains) * env;
			signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};

		/* function for granularize input signal from input 0 */
		~gran_in0 = {
			arg sndbuf, out, gate = 1, vol = 1, amp = 0.9, numChannels, trigger, dur = 1, pan, envbufnum, maxGrains, shiftPan = 0, grainDens = 0.8, mix = 0, room = 0, damp = 0.5, mul = 1;
			var in, env, envRev, signalGrain, signal, signalPan, signalPan1, signalPanRev;
			in = Ndef.ar(\micIn1, 1); // incoming signal
			// controls for grain
			numChannels = 3; // 3 channels diffusion to begin for panning; 3 channels within 8 PanAz channels
			trigger = Dust.ar(grainDens); // density of grain cloud
			pan = SinOsc.kr(400); // panning
			envbufnum = -1;
			maxGrains = 512; // default value
			env = EnvGen.kr(Env.adsr, gate, levelScale: amp, doneAction: 2); // envelope to control overall amplitude of grain cloud
			signal = GrainIn.ar(numChannels, trigger, dur, in, pan, envbufnum, maxGrains) * env;
			//signalPan1 = PanAz.ar(8, signal[0], shiftPan, orientation:0); // without reverb
			signalPan1 = FreeVerb.ar(Resonz.ar(PanAz.ar(8, signal[0], shiftPan, orientation:0), 440, 1, 0.8), mix, room, damp, mul);
			signalPan = signalPan1;
			Out.ar(~ch0, signalPan * vol);
		};


		/***************** speaker test *****************/
		/* function speaker test */
		~sweep_sp1 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch0], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp2 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch1], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp3 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch2], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp4 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch3], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp5 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch4], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp6 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch5], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp7 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch6], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};
		~sweep_sp8 = {
			arg out = 0, bufnum, amp = 0.1;
			Out.ar([~ch7], (PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: 2)) * amp);
		};

		"func and def done".postln;

		/* get midi controller IDs */
		MIDIClient.sources.do{|item|
			if(item.name == "APC MINI", {~apcID = item.uid}); }; // pad controller
		MIDIClient.destinations.do{|item|
			if(item.name == "APC MINI", {~apcOutID = item.uid}); };
		MIDIClient.sources.do{|item|
			if(item.name == "LPD8", {~lpdID = item.uid}); }; // keyboard controller
		MIDIClient.destinations.do{|item|
			if(item.name == "LPD8", {~lpdOutID = item.uid}); };

		/* set midi outputs */
		m = MIDIOut(0, ~apcOutID);
		l = MIDIOut(0, ~lpdOutID);
		"MIDIOut done".postln;


		/* APC slider controls */
		/* slider 1 */
		MIDIdef.cc(\slider1_button01, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep1).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f1).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\f_o).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_2s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_4s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec1_4s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_1357).set(\vol, num.linlin(0, 127, 0, 1));
		}, 48, srcID: ~apcID);

		/* slider 2 */
		MIDIdef.cc(\slider2_button02, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep2).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f2).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\f_e).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_2s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_4s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec1_22s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_2468).set(\vol, num.linlin(0, 127, 0, 1));
		}, 49, srcID: ~apcID);

		/* slider 3 */
		MIDIdef.cc(\slider3_button03, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep3).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f3).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\f_1_8).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_5s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec4_4s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec3_2s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_1357).set(\vol, num.linlin(0, 127, 0, 1));
		}, 50, srcID: ~apcID);

		/* slider 4 */
		MIDIdef.cc(\slider4_button04, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep4).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f4).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\f1_p).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_5s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec5_4s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec6_4s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_2468).set(\vol, num.linlin(0, 127, 0, 1));
		}, 51, srcID: ~apcID);

		/* slider 5 */
		MIDIdef.cc(\slider5_button05, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep5).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f5).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_5s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_22s_b).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec1_8s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_in0).set(\vol, num.linlin(0, 127, 0, 1));
		}, 52, srcID: ~apcID);

		/* slider 6 */
		MIDIdef.cc(\slider6_button06, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep6).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f6).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_17s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec1_17s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec2_8s).set(\vol, num.linlin(0, 127, 0, 1));
		}, 53, srcID: ~apcID);

		/* slider 7 */
		MIDIdef.cc(\slider7_button07, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep7).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f7).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec6_5s).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec4_5s).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\delay_12s_in0).set(\vol, num.linlin(0, 127, 0, 1));
		}, 54, srcID: ~apcID);

		/* slider 8 */
		MIDIdef.cc(\slider8_button08, {
			arg num, id, chan, src;
			//[num, id, chan, src].postln;
			Ndef(\sweep8).set(\amp, num.linlin(0, 127, 0, 0.1));
			Ndef(\f8).set(\vol, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_3s_b).set(\amp, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_rec5_5s).set(\vol, num.linlin(0, 127, 0, 1));
		}, 55, srcID: ~apcID);


		/* LPD control mapping */
		/* LPD knob 1 control panning of incoming signal */
		MIDIdef.cc(\lpdKnob1_panflute_f1_p, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			[num, nn].postln;
			Ndef(\f1_p).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec1_2s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec2_2s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec1_3s_b).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec1_5s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec2_5s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec3_5s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec1_17s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec2_4s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec3_4s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec4_4s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec5_4s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec1_22s_b).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec6_5s).set(\pos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec_wind_low_1357).set(\panPos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec_wind_low_2468).set(\panPos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec_wind_high_1357).set(\panPos, num.linlin(0, 127, 0, 2));
			Ndef(\p_rec_wind_high_2468).set(\panPos, num.linlin(0, 127, 0, 2));
		}, 1, srcID: ~lpdID);

		/* LPD knob 2 control modulation/transposition of incoming signal */
		MIDIdef.cc(\lpdKnob2GranDurBar32, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			//Ndef(\bar32Gran).set(\dur, num.linlin(0, 127, 0.01, 3));
		}, 2, srcID: ~lpdID);

		/* LPD knob 3 control reverb mix dry wet gain */
		MIDIdef.cc(\lpdKnob3, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			Ndef(\f1).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f2).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f3).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f4).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f5).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f6).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f7).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f8).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f_o).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f_e).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f_1_8).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\f1_p).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_2s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_2s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_3s_b).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_5s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_5s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_5s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_17s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_4s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_4s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec4_4s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec5_4s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_22s_b).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec6_5s).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_in0).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_1357).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_2468).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_1357).set(\mix, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_2468).set(\mix, num.linlin(0, 127, 0, 1));
		}, 3, srcID: ~lpdID);

		/* LPD knob 4 control reverb room size */
		MIDIdef.cc(\lpdKnob4, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			Ndef(\f1).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f2).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f3).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f4).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f5).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f6).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f7).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f8).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f_o).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f_e).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f_1_8).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\f1_p).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_2s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_2s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_3s_b).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_5s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_5s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_5s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_17s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec2_4s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec3_4s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec4_4s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec5_4s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec1_22s_b).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec6_5s).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\granularize_in0).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_1357).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_low_2468).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_1357).set(\room, num.linlin(0, 127, 0, 1));
			Ndef(\p_rec_wind_high_2468).set(\room, num.linlin(0, 127, 0, 1));
		}, 4, srcID: ~lpdID);

		/* knob 5 gran dur control */
		MIDIdef.cc(\lpdKnob5, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			Ndef(\granularize_rec1_17s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec4_5s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec5_5s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec1_4s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec1_22s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec3_2s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec6_4s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec1_8s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_rec2_8s).set(\dur, num.linlin(0, 127, 0.01, 3));
			Ndef(\granularize_in0).set(\dur, num.linlin(0, 127, 0.01, 3));
		}, 5, srcID: ~lpdID);

		/* knob 6 gran freq/mod control */
		MIDIdef.cc(\lpdKnob6, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			Ndef(\granularize_rec1_17s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec4_5s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec5_5s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_4s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_22s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec3_2s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec6_4s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_8s).set(\maxRate, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec2_8s).set(\maxRate, num.linlin(0, 127, 0, 2));
		}, 6, srcID: ~lpdID);

		/* knob 7 gran dens control */
		MIDIdef.cc(\lpdKnob7, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			Ndef(\granularize_rec1_17s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec4_5s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec5_5s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec1_4s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec1_22s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec3_2s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec6_4s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec1_8s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_rec2_8s).set(\grainDens, num.linlin(0, 127, 10, 50));
			Ndef(\granularize_in0).set(\grainDens, num.linlin(0, 127, 10, 50));
		}, 7, srcID: ~lpdID);

		/* knbo 8 gran pan control */
		MIDIdef.cc(\lpdKnob8, {
			arg num, nn, chan, src;
			//[num, nn, chan, src].postln;
			[num, nn].postln;
			Ndef(\granularize_rec1_17s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec4_5s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec5_5s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_4s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_22s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec3_2s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec6_4s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec1_8s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_rec2_8s).set(\shiftPan, num.linlin(0, 127, 0, 2));
			Ndef(\granularize_in0).set(\shiftPan, num.linlin(0, 127, 0, 2));
		}, 8, srcID: ~lpdID);



		//////////////////////////////////////// BEGIN /////////////////////////////////////////

		/* trigger sound; APC */
		~midiMapApc = {
			// speaker test button counts
			~countApc01 = 0;
			~countApc02 = 0;
			~countApc03 = 0;
			~countApc04 = 0;
			~countApc05 = 0;
			~countApc06 = 0;
			~countApc07 = 0;
			~countApc08 = 0;

			// amplification button counts
			~countApcf1 = 0;
			~countApcf2 = 0;
			~countApcf3 = 0;
			~countApcf4 = 0;
			~countApcf5 = 0;
			~countApcf6 = 0;
			~countApcf7 = 0;
			~countApcf8 = 0;
			~countApcf_o = 0;
			~countApcf_e = 0;
			~countApcf_1_8 = 0;
			~countApcf1_p = 0;

			// recording button counts
			~countApcRec1_2s = 0;
			~countApcRec2_2s = 0;
			~countApcRec3_2s = 0;
			~countApcRec1_3s = 0;
			~countApcRec1_4s = 0;
			~countApcRec2_4s = 0;
			~countApcRec3_4s = 0;
			~countApcRec4_4s = 0;
			~countApcRec5_4s = 0;
			~countApcRec6_4s = 0;
			~countApcRec1_5s = 0;
			~countApcRec2_5s = 0;
			~countApcRec3_5s = 0;
			~countApcRec4_5s = 0;
			~countApcRec5_5s = 0;
			~countApcRec6_5s = 0;
			~countApcRec1_8s = 0;
			~countApcRec2_8s = 0;
			~countApcRec1_17s = 0;
			~countApcRec1_22s = 0;

			// playback recording counts
			~countApcP_rec1_2s = 0;
			~countApcP_rec2_2s = 0;
			~countApcP_rec1_3s_b = 0;
			~countApcP_rec2_4s = 0;
			~countApcP_rec3_4s = 0;
			~countApcP_rec4_4s = 0;
			~countApcP_rec5_4s = 0;
			~countApcP_rec1_5s = 0;
			~countApcP_rec2_5s = 0;
			~countApcP_rec3_5s = 0;
			~countApcP_rec6_5s = 0;
			~countApcP_rec1_17s = 0;
			~countApcP_rec1_22s_b = 0;
			~countApcP_rec_wind_low_1357 = 0;
			~countApcP_rec_wind_low_2468 = 0;
			~countApcP_rec_wind_high_1357 = 0;
			~countApcP_rec_wind_high_2468 = 0;

			// granularize recording counts
			~countApcGran_rec1_17s = 0;
			~countApcGran_rec4_5s = 0;
			~countApcGran_rec5_5s = 0;
			~countApcGran_rec1_4s = 0;
			~countApcGran_rec1_22s = 0;
			~countApcGran_rec3_2s = 0;
			~countApcGran_rec6_4s = 0;
			~countApcGran_rec1_8s = 0;
			~countApcGran_rec2_8s = 0;

			// granularize input signal counts
			~countApcGran_input0 = 0;

			// delay input signal counts
			~countApcDelay_12s_in0 = 0;


			//////////////////// button f1 //////////////////// bar X
			MIDIdef.noteOn(\apcButton56, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 1 */
				if (~countApcf1 == 0, {
					~f1 = Ndef(\f1, ~amplifyFluteThru1);
					m.noteOn(0, 56, 01); //light on
					"on 56 button f1".postln;
					~countApcf1 = 1;
				}, {
					~f1.release(1);
					m.noteOn(0, 56, 0); //light off
					"off 56 button f1".postln;
					~countApcf1 = 0;
				});
			}, 56, srcID: ~apcID);

			//////////////////// button f2 //////////////////// bar X
			MIDIdef.noteOn(\apcButton57, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 2 */
				if (~countApcf2 == 0, {
					~f2 = Ndef(\f2, ~amplifyFluteThru2);
					m.noteOn(0, 57, 01); //light on
					"on 57 button f2".postln;
					~countApcf2 = 1;
				}, {
					~f2.release(1);
					m.noteOn(0, 57, 0); //light off
					"off 57 button f2".postln;
					~countApcf2 = 0;
				});
			}, 57, srcID: ~apcID);

			//////////////////// button f3 //////////////////// bar X
			MIDIdef.noteOn(\apcButton58, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 3 */
				if (~countApcf3 == 0, {
					~f3 = Ndef(\f3, ~amplifyFluteThru3);
					m.noteOn(0, 58, 01); //light on
					"on 58 button f3".postln;
					~countApcf3 = 1;
				}, {
					~f3.release(1);
					m.noteOn(0, 58, 0); //light off
					"off 58 button f3".postln;
					~countApcf3 = 0;
				});
			}, 58, srcID: ~apcID);

			//////////////////// button f4 //////////////////// bar X
			MIDIdef.noteOn(\apcButton59, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 4 */
				if (~countApcf4 == 0, {
					~f4 = Ndef(\f4, ~amplifyFluteThru4);
					m.noteOn(0, 59, 01); //light on
					"on 59 button f4".postln;
					~countApcf4 = 1;
				}, {
					~f4.release(1);
					m.noteOn(0, 59, 0); //light off
					"off 59 button f4".postln;
					~countApcf4 = 0;
				});
			}, 59, srcID: ~apcID);

			//////////////////// button f5 //////////////////// bar X
			MIDIdef.noteOn(\apcButton60, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 5 */
				if (~countApcf5 == 0, {
					~f5 = Ndef(\f5, ~amplifyFluteThru5);
					m.noteOn(0, 60, 01); //light on
					"on 60 button f5".postln;
					~countApcf5 = 1;
				}, {
					~f5.release(1);
					m.noteOn(0, 60, 0); //light off
					"off 60 button f5".postln;
					~countApcf5 = 0;
				});
			}, 60, srcID: ~apcID);

			//////////////////// button f6 //////////////////// bar X
			MIDIdef.noteOn(\apcButton61, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 6 */
				if (~countApcf6 == 0, {
					~f6 = Ndef(\f6, ~amplifyFluteThru6);
					m.noteOn(0, 61, 01); //light on
					"on 61 button f6".postln;
					~countApcf6 = 1;
				}, {
					~f6.release(1);
					m.noteOn(0, 61, 0); //light off
					"off 61 button f6".postln;
					~countApcf6 = 0;
				});
			}, 61, srcID: ~apcID);

			//////////////////// button f7 //////////////////// bar X
			MIDIdef.noteOn(\apcButton62, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 7 */
				if (~countApcf7 == 0, {
					~f7 = Ndef(\f7, ~amplifyFluteThru7);
					m.noteOn(0, 62, 01); //light on
					"on 62 button f7".postln;
					~countApcf7 = 1;
				}, {
					~f7.release(1);
					m.noteOn(0, 62, 0); //light off
					"off 62 button f7".postln;
					~countApcf7 = 0;
				});
			}, 62, srcID: ~apcID);

			//////////////////// button f8 //////////////////// bar X
			MIDIdef.noteOn(\apcButton63, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 8 */
				if (~countApcf8 == 0, {
					~f8 = Ndef(\f8, ~amplifyFluteThru8);
					m.noteOn(0, 63, 01); //light on
					"on 63 button f8".postln;
					~countApcf8 = 1;
				}, {
					~f8.release(1);
					m.noteOn(0, 63, 0); //light off
					"off 63 button f8".postln;
					~countApcf8 = 0;
				});
			}, 63, srcID: ~apcID);

			//////////////////// button f_o //////////////////// bar X
			MIDIdef.noteOn(\apcButton48, {
				arg vel, nn, chan, src;
				/* amplify flute through speakers 1357 */
				if (~countApcf_o == 0, {
					~f_o = Ndef(\f_o, ~amplifyFluteThru_o);
					m.noteOn(0, 48, 01); //light on
					"on 48 button f_o".postln;
					~countApcf_o = 1;
				}, {
					~f_o.release(1);
					m.noteOn(0, 48, 0); //light off
					"off 48 button f_o".postln;
					~countApcf_o = 0;
				});
			}, 48, srcID: ~apcID);

			//////////////////// button f_e //////////////////// bar X
			MIDIdef.noteOn(\apcButton49, {
				arg vel, nn, chan, src;
				/* amplify flute through speakers 2468 */
				if (~countApcf_e == 0, {
					~f_e = Ndef(\f_e, ~amplifyFluteThru_e);
					m.noteOn(0, 49, 01); //light on
					"on 49 button f_e".postln;
					~countApcf_e = 1;
				}, {
					~f_e.release(1);
					m.noteOn(0, 49, 0); //light off
					"off 49 button f_e".postln;
					~countApcf_e = 0;
				});
			}, 49, srcID: ~apcID);

			//////////////////// button f_1_8 //////////////////// bar X
			MIDIdef.noteOn(\apcButton50, {
				arg vel, nn, chan, src;
				/* amplify flute through speakers 1-8 */
				if (~countApcf_1_8 == 0, {
					~f_1_8 = Ndef(\f_1_8, ~amplifyFluteThru_1_8);
					m.noteOn(0, 50, 01); //light on
					"on 50 button f_1_8".postln;
					~countApcf_1_8 = 1;
				}, {
					~f_1_8.release(1);
					m.noteOn(0, 50, 0); //light off
					"off 50 button f_1_8".postln;
					~countApcf_1_8 = 0;
				});
			}, 50, srcID: ~apcID);

			//////////////////// button f1_p //////////////////// bar X
			MIDIdef.noteOn(\apcButton51, {
				arg vel, nn, chan, src;
				/* amplify flute through speaker 1, with panning */
				if (~countApcf1_p == 0, {
					~f1_p = Ndef(\f1_p, ~amplifyFluteThru1_p).play;
					m.noteOn(0, 51, 01); //light on
					"on 51 button f1_p".postln;
					~countApcf1_p = 1;
				}, {
					~f1_p.release(1); // fade
					~f1_p.stop; // stop .play
					m.noteOn(0, 51, 0); //light off
					"off 51 button f1_p".postln;
					~countApcf1_p = 0;
				});
			}, 51, srcID: ~apcID);


			//////////////////// button rec1_2s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_2s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_2s = {
					m.noteOn(0, 24, 03); // button color red
					/* record 1 */
					~rec1_2s = Synth(\SoundIn, [\bufnum, ~buf_rec1_2s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_2s = 1;
					~recording_rec1_2s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_2s = {
					~rec1_2s.free; // stop synth for recording
					~buf_rec1_2s.free; // free buffer
					~recording_rec1_2s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_2s = Routine {
						~buf_rec1_2s = Buffer.alloc(s, 44100 * ~bufLength_rec1_2s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_2s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_2s = {
					m.noteOn(0, 24, 0); // light off
					~recording_rec1_2s = false;
					~countApcRec1_2s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_2s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_2s = {
						~recStart_rec1_2s.();
						"on 24 button rec1_2s".postln;
						~bufLength_rec1_2s.yield; // time when recording into buffer
						if(~recording_rec1_2s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_2s.();
							"off 24 button rec1_2s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_2s == 1, {
						~recRout_rec1_2s.stop; // stop routine for sanity
						~recStop_rec1_2s.(); // call to stop recording and free buffer
						"off 24 button rec1_2s".postln;
						m.noteOn(0, 24, 0); // light off
					});
				});
			}, 24, srcID: ~apcID); // APC midi number 24


			//////////////////// button rec2_2s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec2_2s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec2_2s = {
					m.noteOn(0, 25, 03); // button color red
					/* record 1 */
					~rec2_2s = Synth(\SoundIn, [\bufnum, ~buf_rec2_2s]); // start recording (no playback)
					"recording".postln;
					~countApcRec2_2s = 1;
					~recording_rec2_2s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec2_2s = {
					~rec2_2s.free; // stop synth for recording
					~buf_rec2_2s.free; // free buffer
					~recording_rec2_2s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec2_2s = Routine {
						~buf_rec2_2s = Buffer.alloc(s, 44100 * ~bufLength_rec2_2s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec2_2s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec2_2s = {
					m.noteOn(0, 25, 0); // light off
					~recording_rec2_2s = false;
					~countApcRec2_2s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec2_2s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec2_2s = {
						~recStart_rec2_2s.();
						"on 25 button rec2_2s".postln;
						~bufLength_rec2_2s.yield; // time when recording into buffer
						if(~recording_rec2_2s, {
							"recording complete".postln;
							~recCompleteLightOff_rec2_2s.();
							"off 25 button rec2_2s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec2_2s == 1, {
						~recRout_rec2_2s.stop; // stop routine for sanity
						~recStop_rec2_2s.(); // call to stop recording and free buffer
						"off 25 button rec2_2s".postln;
						m.noteOn(0, 25, 0); // light off
					});
				});
			}, 25, srcID: ~apcID); // APC midi number 25


			//////////////////// button rec3_2s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec3_2s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec3_2s = {
					m.noteOn(0, 39, 03); // button color red
					/* record 1 */
					~rec3_2s = Synth(\SoundIn, [\bufnum, ~buf_rec3_2s]); // start recording (no playback)
					"recording".postln;
					~countApcRec3_2s = 1;
					~recording_rec3_2s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec3_2s = {
					~rec3_2s.free; // stop synth for recording
					~buf_rec3_2s.free; // free buffer
					~recording_rec3_2s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec3_2s = Routine {
						~buf_rec3_2s = Buffer.alloc(s, 44100 * ~bufLength_rec3_2s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec3_2s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec3_2s = {
					m.noteOn(0, 39, 0); // light off
					~recording_rec3_2s = false;
					~countApcRec3_2s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec3_2s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec3_2s = {
						~recStart_rec3_2s.();
						"on 39 button rec3_2s".postln;
						~bufLength_rec3_2s.yield; // time when recording into buffer
						if(~recording_rec3_2s, {
							"recording complete".postln;
							~recCompleteLightOff_rec3_2s.();
							"off 39 button rec3_2s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec3_2s == 1, {
						~recRout_rec3_2s.stop; // stop routine for sanity
						~recStop_rec3_2s.(); // call to stop recording and free buffer
						"off 39 button rec3_2s".postln;
						m.noteOn(0, 39, 0); // light off
					});
				});
			}, 39, srcID: ~apcID); // APC midi number 39


			//////////////////// button rec1_3s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_3s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_3s = {
					m.noteOn(0, 31, 03); // button color red
					/* record 1 */
					~rec1_3s = Synth(\SoundIn, [\bufnum, ~buf_rec1_3s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_3s = 1;
					~recording_rec1_3s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_3s = {
					~rec1_3s.free; // stop synth for recording
					~buf_rec1_3s.free; // free buffer
					~recording_rec1_3s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_3s = Routine {
						~buf_rec1_3s = Buffer.alloc(s, 44100 * ~bufLength_rec1_3s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_3s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_3s = {
					m.noteOn(0, 31, 0); // light off
					~recording_rec1_3s = false;
					~countApcRec1_3s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_3s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_3s = {
						~recStart_rec1_3s.();
						"on 31 button rec1_3s".postln;
						~bufLength_rec1_3s.yield; // time when recording into buffer
						if(~recording_rec1_3s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_3s.();
							"off 31 button rec1_3s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_3s == 1, {
						~recRout_rec1_3s.stop; // stop routine for sanity
						~recStop_rec1_3s.(); // call to stop recording and free buffer
						"off 31 button rec1_3s".postln;
						m.noteOn(0, 31, 0); // light off
					});
				});
			}, 31, srcID: ~apcID); // APC midi number 31


			//////////////////// button rec1_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_4s = {
					m.noteOn(0, 13, 03); // button color red
					/* record 1 */
					~rec1_4s = Synth(\SoundIn, [\bufnum, ~buf_rec1_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_4s = 1;
					~recording_rec1_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_4s = {
					~rec1_4s.free; // stop synth for recording
					~buf_rec1_4s.free; // free buffer
					~recording_rec1_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_4s = Routine {
						~buf_rec1_4s = Buffer.alloc(s, 44100 * ~bufLength_rec1_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_4s = {
					m.noteOn(0, 13, 0); // light off
					~recording_rec1_4s = false;
					~countApcRec1_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_4s = {
						~recStart_rec1_4s.();
						"on 13 button rec1_4s".postln;
						~bufLength_rec1_4s.yield; // time when recording into buffer
						if(~recording_rec1_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_4s.();
							"off 13 button rec1_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_4s == 1, {
						~recRout_rec1_4s.stop; // stop routine for sanity
						~recStop_rec1_4s.(); // call to stop recording and free buffer
						"off 13 button rec1_4s".postln;
						m.noteOn(0, 13, 0); // light off
					});
				});
			}, 13, srcID: ~apcID); // APC midi number 13


			//////////////////// button rec2_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec2_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec2_4s = {
					m.noteOn(0, 08, 03); // button color red
					/* record 1 */
					~rec2_4s = Synth(\SoundIn, [\bufnum, ~buf_rec2_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec2_4s = 1;
					~recording_rec2_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec2_4s = {
					~rec2_4s.free; // stop synth for recording
					~buf_rec2_4s.free; // free buffer
					~recording_rec2_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec2_4s = Routine {
						~buf_rec2_4s = Buffer.alloc(s, 44100 * ~bufLength_rec2_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec2_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec2_4s = {
					m.noteOn(0, 08, 0); // light off
					~recording_rec2_4s = false;
					~countApcRec2_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec2_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec2_4s = {
						~recStart_rec2_4s.();
						"on 8 button rec2_4s".postln;
						~bufLength_rec2_4s.yield; // time when recording into buffer
						if(~recording_rec2_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec2_4s.();
							"off 8 button rec2_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec2_4s == 1, {
						~recRout_rec2_4s.stop; // stop routine for sanity
						~recStop_rec2_4s.(); // call to stop recording and free buffer
						"off 8 button rec2_4s".postln;
						m.noteOn(0, 08, 0); // light off
					});
				});
			}, 08, srcID: ~apcID); // APC midi number 08


			//////////////////// button rec3_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec3_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec3_4s = {
					m.noteOn(0, 09, 03); // button color red
					/* record 1 */
					~rec3_4s = Synth(\SoundIn, [\bufnum, ~buf_rec3_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec3_4s = 1;
					~recording_rec3_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec3_4s = {
					~rec3_4s.free; // stop synth for recording
					~buf_rec3_4s.free; // free buffer
					~recording_rec3_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec3_4s = Routine {
						~buf_rec3_4s = Buffer.alloc(s, 44100 * ~bufLength_rec3_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec3_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec3_4s = {
					m.noteOn(0, 09, 0); // light off
					~recording_rec3_4s = false;
					~countApcRec3_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec3_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec3_4s = {
						~recStart_rec3_4s.();
						"on 9 button rec3_4s".postln;
						~bufLength_rec3_4s.yield; // time when recording into buffer
						if(~recording_rec3_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec3_4s.();
							"off 9 button rec3_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec3_4s == 1, {
						~recRout_rec3_4s.stop; // stop routine for sanity
						~recStop_rec3_4s.(); // call to stop recording and free buffer
						"off 9 button rec3_4s".postln;
						m.noteOn(0, 09, 0); // light off
					});
				});
			}, 09, srcID: ~apcID); // APC midi number 09


			//////////////////// button rec4_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec4_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec4_4s = {
					m.noteOn(0, 10, 03); // button color red
					/* record 1 */
					~rec4_4s = Synth(\SoundIn, [\bufnum, ~buf_rec4_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec4_4s = 1;
					~recording_rec4_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec4_4s = {
					~rec4_4s.free; // stop synth for recording
					~buf_rec4_4s.free; // free buffer
					~recording_rec4_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec4_4s = Routine {
						~buf_rec4_4s = Buffer.alloc(s, 44100 * ~bufLength_rec4_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec4_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec4_4s = {
					m.noteOn(0, 10, 0); // light off
					~recording_rec4_4s = false;
					~countApcRec4_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec4_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec4_4s = {
						~recStart_rec4_4s.();
						"on 10 button rec4_4s".postln;
						~bufLength_rec4_4s.yield; // time when recording into buffer
						if(~recording_rec4_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec4_4s.();
							"off 10 button rec4_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec4_4s == 1, {
						~recRout_rec4_4s.stop; // stop routine for sanity
						~recStop_rec4_4s.(); // call to stop recording and free buffer
						"off 10 button rec4_4s".postln;
						m.noteOn(0, 10, 0); // light off
					});
				});
			}, 10, srcID: ~apcID); // APC midi number 09


			//////////////////// button rec5_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec5_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec5_4s = {
					m.noteOn(0, 11, 03); // button color red
					/* record 1 */
					~rec5_4s = Synth(\SoundIn, [\bufnum, ~buf_rec5_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec5_4s = 1;
					~recording_rec5_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec5_4s = {
					~rec5_4s.free; // stop synth for recording
					~buf_rec5_4s.free; // free buffer
					~recording_rec5_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec5_4s = Routine {
						~buf_rec5_4s = Buffer.alloc(s, 44100 * ~bufLength_rec5_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec5_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec5_4s = {
					m.noteOn(0, 11, 0); // light off
					~recording_rec5_4s = false;
					~countApcRec5_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec5_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec5_4s = {
						~recStart_rec5_4s.();
						"on 11 button rec5_4s".postln;
						~bufLength_rec5_4s.yield; // time when recording into buffer
						if(~recording_rec5_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec5_4s.();
							"off 11 button rec5_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec5_4s == 1, {
						~recRout_rec5_4s.stop; // stop routine for sanity
						~recStop_rec5_4s.(); // call to stop recording and free buffer
						"off 11 button rec5_4s".postln;
						m.noteOn(0, 11, 0); // light off
					});
				});
			}, 11, srcID: ~apcID); // APC midi number 11


			//////////////////// button rec6_4s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec6_4s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec6_4s = {
					m.noteOn(0, 07, 03); // button color red
					/* record 1 */
					~rec6_4s = Synth(\SoundIn, [\bufnum, ~buf_rec6_4s]); // start recording (no playback)
					"recording".postln;
					~countApcRec6_4s = 1;
					~recording_rec6_4s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec6_4s = {
					~rec6_4s.free; // stop synth for recording
					~buf_rec6_4s.free; // free buffer
					~recording_rec6_4s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec6_4s = Routine {
						~buf_rec6_4s = Buffer.alloc(s, 44100 * ~bufLength_rec6_4s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec6_4s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec6_4s = {
					m.noteOn(0, 07, 0); // light off
					~recording_rec6_4s = false;
					~countApcRec6_4s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec6_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec6_4s = {
						~recStart_rec6_4s.();
						"on 07 button rec6_4s".postln;
						~bufLength_rec6_4s.yield; // time when recording into buffer
						if(~recording_rec6_4s, {
							"recording complete".postln;
							~recCompleteLightOff_rec6_4s.();
							"off 07 button rec6_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec6_4s == 1, {
						~recRout_rec6_4s.stop; // stop routine for sanity
						~recStop_rec6_4s.(); // call to stop recording and free buffer
						"off 07 button rec6_4s".postln;
						m.noteOn(0, 07, 0); // light off
					});
				});
			}, 07, srcID: ~apcID); // APC midi number 07


			//////////////////// button rec1_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_5s = {
					m.noteOn(0, 26, 03); // button color red
					/* record 1 */
					~rec1_5s = Synth(\SoundIn, [\bufnum, ~buf_rec1_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_5s = 1;
					~recording_rec1_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_5s = {
					~rec1_5s.free; // stop synth for recording
					~buf_rec1_5s.free; // free buffer
					~recording_rec1_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_5s = Routine {
						~buf_rec1_5s = Buffer.alloc(s, 44100 * ~bufLength_rec1_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_5s = {
					m.noteOn(0, 26, 0); // light off
					~recording_rec1_5s = false;
					~countApcRec1_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_5s = {
						~recStart_rec1_5s.();
						"on 26 button rec1_5s".postln;
						~bufLength_rec1_5s.yield; // time when recording into buffer
						if(~recording_rec1_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_5s.();
							"off 26 button rec1_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_5s == 1, {
						~recRout_rec1_5s.stop; // stop routine for sanity
						~recStop_rec1_5s.(); // call to stop recording and free buffer
						"off 26 button rec1_5s".postln;
						m.noteOn(0, 26, 0); // light off
					});
				});
			}, 26, srcID: ~apcID); // APC midi number 26


			//////////////////// button rec2_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec2_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec2_5s = {
					m.noteOn(0, 27, 03); // button color red
					/* record 1 */
					~rec2_5s = Synth(\SoundIn, [\bufnum, ~buf_rec2_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec2_5s = 1;
					~recording_rec2_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec2_5s = {
					~rec2_5s.free; // stop synth for recording
					~buf_rec2_5s.free; // free buffer
					~recording_rec2_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec2_5s = Routine {
						~buf_rec2_5s = Buffer.alloc(s, 44100 * ~bufLength_rec2_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec2_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec2_5s = {
					m.noteOn(0, 27, 0); // light off
					~recording_rec2_5s = false;
					~countApcRec2_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec2_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec2_5s = {
						~recStart_rec2_5s.();
						"on 27 button rec2_5s".postln;
						~bufLength_rec2_5s.yield; // time when recording into buffer
						if(~recording_rec2_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec2_5s.();
							"off 27 button rec2_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec2_5s == 1, {
						~recRout_rec2_5s.stop; // stop routine for sanity
						~recStop_rec2_5s.(); // call to stop recording and free buffer
						"off 27 button rec2_5s".postln;
						m.noteOn(0, 27, 0); // light off
					});
				});
			}, 27, srcID: ~apcID); // APC midi number 27


			//////////////////// button rec3_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec3_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec3_5s = {
					m.noteOn(0, 28, 03); // button color red
					/* record 1 */
					~rec3_5s = Synth(\SoundIn, [\bufnum, ~buf_rec3_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec3_5s = 1;
					~recording_rec3_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec3_5s = {
					~rec3_5s.free; // stop synth for recording
					~buf_rec3_5s.free; // free buffer
					~recording_rec3_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec3_5s = Routine {
						~buf_rec3_5s = Buffer.alloc(s, 44100 * ~bufLength_rec3_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec3_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec3_5s = {
					m.noteOn(0, 28, 0); // light off
					~recording_rec3_5s = false;
					~countApcRec3_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec3_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec3_5s = {
						~recStart_rec3_5s.();
						"on 28 button rec3_5s".postln;
						~bufLength_rec3_5s.yield; // time when recording into buffer
						if(~recording_rec3_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec3_5s.();
							"off 28 button rec3_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec3_5s == 1, {
						~recRout_rec3_5s.stop; // stop routine for sanity
						~recStop_rec3_5s.(); // call to stop recording and free buffer
						"off 28 button rec3_5s".postln;
						m.noteOn(0, 28, 0); // light off
					});
				});
			}, 28, srcID: ~apcID); // APC midi number 28


			//////////////////// button rec4_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec4_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec4_5s = {
					m.noteOn(0, 05, 03); // button color red
					/* record 1 */
					~rec4_5s = Synth(\SoundIn, [\bufnum, ~buf_rec4_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec4_5s = 1;
					~recording_rec4_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec4_5s = {
					~rec4_5s.free; // stop synth for recording
					~buf_rec4_5s.free; // free buffer
					~recording_rec4_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec4_5s = Routine {
						~buf_rec4_5s = Buffer.alloc(s, 44100 * ~bufLength_rec4_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec4_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec4_5s = {
					m.noteOn(0, 05, 0); // light off
					~recording_rec4_5s = false;
					~countApcRec4_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec4_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec4_5s = {
						~recStart_rec4_5s.();
						"on 05 button rec4_5s".postln;
						~bufLength_rec4_5s.yield; // time when recording into buffer
						if(~recording_rec4_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec4_5s.();
							"off 05 button rec4_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec4_5s == 1, {
						~recRout_rec4_5s.stop; // stop routine for sanity
						~recStop_rec4_5s.(); // call to stop recording and free buffer
						"off 05 button rec4_5s".postln;
						m.noteOn(0, 05, 0); // light off
					});
				});
			}, 05, srcID: ~apcID); // APC midi number 05


			//////////////////// button rec5_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec5_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec5_5s = {
					m.noteOn(0, 06, 03); // button color red
					/* record 1 */
					~rec5_5s = Synth(\SoundIn, [\bufnum, ~buf_rec5_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec5_5s = 1;
					~recording_rec5_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec5_5s = {
					~rec5_5s.free; // stop synth for recording
					~buf_rec5_5s.free; // free buffer
					~recording_rec5_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec5_5s = Routine {
						~buf_rec5_5s = Buffer.alloc(s, 44100 * ~bufLength_rec5_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec5_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec5_5s = {
					m.noteOn(0, 06, 0); // light off
					~recording_rec5_5s = false;
					~countApcRec5_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec5_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec5_5s = {
						~recStart_rec5_5s.();
						"on 06 button rec5_5s".postln;
						~bufLength_rec5_5s.yield; // time when recording into buffer
						if(~recording_rec5_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec5_5s.();
							"off 06 button rec5_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec5_5s == 1, {
						~recRout_rec5_5s.stop; // stop routine for sanity
						~recStop_rec5_5s.(); // call to stop recording and free buffer
						"off 06 button rec5_5s".postln;
						m.noteOn(0, 06, 0); // light off
					});
				});
			}, 06, srcID: ~apcID); // APC midi number 06


			//////////////////// button rec6_5s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec6_5s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec6_5s = {
					m.noteOn(0, 30, 03); // button color red
					/* record 1 */
					~rec6_5s = Synth(\SoundIn, [\bufnum, ~buf_rec6_5s]); // start recording (no playback)
					"recording".postln;
					~countApcRec6_5s = 1;
					~recording_rec6_5s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec6_5s = {
					~rec6_5s.free; // stop synth for recording
					~buf_rec6_5s.free; // free buffer
					~recording_rec6_5s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec6_5s = Routine {
						~buf_rec6_5s = Buffer.alloc(s, 44100 * ~bufLength_rec6_5s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec6_5s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec6_5s = {
					m.noteOn(0, 30, 0); // light off
					~recording_rec6_5s = false;
					~countApcRec6_5s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec6_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec6_5s = {
						~recStart_rec6_5s.();
						"on 30 button rec6_5s".postln;
						~bufLength_rec6_5s.yield; // time when recording into buffer
						if(~recording_rec6_5s, {
							"recording complete".postln;
							~recCompleteLightOff_rec6_5s.();
							"off 30 button rec6_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec6_5s == 1, {
						~recRout_rec6_5s.stop; // stop routine for sanity
						~recStop_rec6_5s.(); // call to stop recording and free buffer
						"off 30 button rec6_5s".postln;
						m.noteOn(0, 30, 0); // light off
					});
				});
			}, 30, srcID: ~apcID); // APC midi number 30


			//////////////////// button rec1_8s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_8s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_8s = {
					m.noteOn(0, 14, 03); // button color red
					/* record 1 */
					~rec1_8s = Synth(\SoundIn, [\bufnum, ~buf_rec1_8s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_8s = 1;
					~recording_rec1_8s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_8s = {
					~rec1_8s.free; // stop synth for recording
					~buf_rec1_8s.free; // free buffer
					~recording_rec1_8s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_8s = Routine {
						~buf_rec1_8s = Buffer.alloc(s, 44100 * ~bufLength_rec1_8s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_8s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_8s = {
					m.noteOn(0, 14, 0); // light off
					~recording_rec1_8s = false;
					~countApcRec1_8s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_8s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_8s = {
						~recStart_rec1_8s.();
						"on 14 button rec1_8s".postln;
						~bufLength_rec1_8s.yield; // time when recording into buffer
						if(~recording_rec1_8s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_8s.();
							"off 14 button rec1_8s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_8s == 1, {
						~recRout_rec1_8s.stop; // stop routine for sanity
						~recStop_rec1_8s.(); // call to stop recording and free buffer
						"off 14 button rec1_8s".postln;
						m.noteOn(0, 14, 0); // light off
					});
				});
			}, 14, srcID: ~apcID); // APC midi number 06


			//////////////////// button rec2_8s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec2_8s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec2_8s = {
					m.noteOn(0, 15, 03); // button color red
					/* record 1 */
					~rec2_8s = Synth(\SoundIn, [\bufnum, ~buf_rec2_8s]); // start recording (no playback)
					"recording".postln;
					~countApcRec2_8s = 1;
					~recording_rec2_8s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec2_8s = {
					~rec2_8s.free; // stop synth for recording
					~buf_rec2_8s.free; // free buffer
					~recording_rec2_8s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec2_8s = Routine {
						~buf_rec2_8s = Buffer.alloc(s, 44100 * ~bufLength_rec2_8s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec2_8s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec2_8s = {
					m.noteOn(0, 15, 0); // light off
					~recording_rec2_8s = false;
					~countApcRec2_8s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec2_8s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec2_8s = {
						~recStart_rec2_8s.();
						"on 15 button rec2_8s".postln;
						~bufLength_rec2_8s.yield; // time when recording into buffer
						if(~recording_rec2_8s, {
							"recording complete".postln;
							~recCompleteLightOff_rec2_8s.();
							"off 15 button rec2_8s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec2_8s == 1, {
						~recRout_rec2_8s.stop; // stop routine for sanity
						~recStop_rec2_8s.(); // call to stop recording and free buffer
						"off 15 button rec2_8s".postln;
						m.noteOn(0, 15, 0); // light off
					});
				});
			}, 15, srcID: ~apcID); // APC midi number 06


			//////////////////// button rec1_17s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_17s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_17s = {
					m.noteOn(0, 29, 03); // button color red
					/* record 1 */
					~rec1_17s = Synth(\SoundIn, [\bufnum, ~buf_rec1_17s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_17s = 1;
					~recording_rec1_17s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_17s = {
					~rec1_17s.free; // stop synth for recording
					~buf_rec1_17s.free; // free buffer
					~recording_rec1_17s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_17s = Routine {
						~buf_rec1_17s = Buffer.alloc(s, 44100 * ~bufLength_rec1_17s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_17s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_17s = {
					m.noteOn(0, 29, 0); // light off
					~recording_rec1_17s = false;
					~countApcRec1_17s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_17s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_17s = {
						~recStart_rec1_17s.();
						"on 29 button rec1_17s".postln;
						~bufLength_rec1_17s.yield; // time when recording into buffer
						if(~recording_rec1_17s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_17s.();
							"off 29 button rec1_17s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_17s == 1, {
						~recRout_rec1_17s.stop; // stop routine for sanity
						~recStop_rec1_17s.(); // call to stop recording and free buffer
						"off 29 button rec1_17s".postln;
						m.noteOn(0, 29, 0); // light off
					});
				});
			}, 29, srcID: ~apcID); // APC midi number 29


			//////////////////// button rec1_22s //////////////////// bar X
			MIDIdef.noteOn(\apcButtonRec1_22s, {
				arg vel, nn, chan, src;
				/* start recording into buffer */
				~recStart_rec1_22s = {
					m.noteOn(0, 12, 03); // button color red
					/* record 1 */
					~rec1_22s = Synth(\SoundIn, [\bufnum, ~buf_rec1_22s]); // start recording (no playback)
					"recording".postln;
					~countApcRec1_22s = 1;
					~recording_rec1_22s = true;
				};
				/* stop recording and free buffer */
				~recStop_rec1_22s = {
					~rec1_22s.free; // stop synth for recording
					~buf_rec1_22s.free; // free buffer
					~recording_rec1_22s = false;
					// realocate buffer to be recorded into again
					~waitForBufferReallocation_rec1_22s = Routine {
						~buf_rec1_22s = Buffer.alloc(s, 44100 * ~bufLength_rec1_22s, 1); // allocate buffer to record for 20 seconds for rec 1
						s.sync;
					}.value;
					"recording stopped, buffer reallocated".postln;
					~countApcRec1_22s = 0;
				};
				/* function to turn light off after recording */
				~recCompleteLightOff_rec1_22s = {
					m.noteOn(0, 12, 0); // light off
					~recording_rec1_22s = false;
					~countApcRec1_22s = 0;
				};

				/* button press for button 1 */
				/* record 2 seconds of flute into ~buf_rec1_2s through Shure SM57 dynamic mic */
				if (~countApcRec1_22s == 0, {
					// routine to start recording and turn light off after recording is completed
					~recRout_rec1_22s = {
						~recStart_rec1_22s.();
						"on 12 button rec1_22s".postln;
						~bufLength_rec1_22s.yield; // time when recording into buffer
						if(~recording_rec1_22s, {
							"recording complete".postln;
							~recCompleteLightOff_rec1_22s.();
							"off 12 button rec1_22s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of recording and reallocate buffer for recording again; press again off
					if (~countApcRec1_22s == 1, {
						~recRout_rec1_22s.stop; // stop routine for sanity
						~recStop_rec1_22s.(); // call to stop recording and free buffer
						"off 12 button rec1_22s".postln;
						m.noteOn(0, 12, 0); // light off
					});
				});
			}, 12, srcID: ~apcID); // APC midi number 12



			/****************************************** playback ******************************************/

			/* playback rec1_2s */
			MIDIdef.noteOn(\apcButton_p_rec1_2s, {
				arg vel, nn, chan, src;
				~playbackStart_rec1_2s = {
					m.noteOn(0, 16, 01); // light on
					/* playback */
					~p_rec1_2s = Ndef(\p_rec1_2s, ~playback_rec1_2s);
					Ndef(\p_rec1_2s).set(\bufnum, ~buf_rec1_2s);
					"playing p_rec1_2s".postln;
					~countApcP_rec1_2s = 1;
					~boo_p_rec1_2s = true; // bolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec1_2s = {
					~p_rec1_2s.free; // stop play back
					~boo_p_rec1_2s = false;
					"playback stopped".postln;
					~countApcP_rec1_2s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec1_2s = {
					m.noteOn(0, 16, 0); // light off
					~boo_p_rec1_2s = false;
					~countApcP_rec1_2s = 0;
				};

				/* press button 16 */
				if (~countApcP_rec1_2s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec1_2s = {
						~playbackStart_rec1_2s.();
						"on 16 button p_rec1_2s".postln;
						~bufLength_rec1_2s.yield; // time when playing back buffer
						if(~boo_p_rec1_2s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec1_2s.();
							"off 16 button p_rec1_2s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec1_2s == 1, {
						~playbackRout_rec1_2s.stop; // stop routine for sanity
						~playbackStop_rec1_2s.(); // call to stop recording and free buffer
						"off 16 button p_rec1_2s".postln;
						m.noteOn(0, 16, 0); // light off
					});
				});
			}, 16, srcID: ~apcID);

			/* playback rec2_2s*/
			MIDIdef.noteOn(\apcButton_p_rec2_2s, {
				arg vel, nn, chan, src;
				~playbackStart_rec2_2s = {
					m.noteOn(0, 17, 01); // light on
					/* playback */
					~p_rec2_2s = Ndef(\p_rec2_2s, ~playback_rec2_2s);
					Ndef(\p_rec2_2s).set(\bufnum, ~buf_rec2_2s);
					"playing p_rec2_2s".postln;
					~countApcP_rec2_2s = 1;
					~boo_p_rec2_2s = true; // bolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec2_2s = {
					~p_rec2_2s.free; // stop play back
					~boo_p_rec2_2s = false;
					"playback stopped".postln;
					~countApcP_rec2_2s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec2_2s = {
					m.noteOn(0, 17, 0); // light off
					~boo_p_rec2_2s = false;
					~countApcP_rec2_2s = 0;
				};

				/* press button 17 */
				if (~countApcP_rec2_2s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec2_2s = {
						~playbackStart_rec2_2s.();
						"on 17 button p_rec2_2s".postln;
						~bufLength_rec2_2s.yield; // time when playing back buffer
						if(~boo_p_rec2_2s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec2_2s.();
							"off 17 button p_rec2_2s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec2_2s == 1, {
						~playbackRout_rec2_2s.stop; // stop routine for sanity
						~playbackStop_rec2_2s.(); // call to stop recording and free buffer
						"off 17 button p_rec2_2s".postln;
						m.noteOn(0, 17, 0); // light off
					});
				});
			}, 17, srcID: ~apcID);

			/* playback rec1_3s_b*/
			MIDIdef.noteOn(\apcButton_p_rec1_3s_b, {
				arg vel, nn, chan, src;
				~playbackStart_rec1_3s_b = {
					m.noteOn(0, 23, 01); // light on
					/* playback */
					~p_rec1_3s_b = Ndef(\p_rec1_3s_b, ~playback_rec1_3s_b);
					Ndef(\p_rec1_3s_b).set(\bufnum, ~buf_rec1_3s);
					"playing p_rec1_3s_b".postln;
					~countApcP_rec1_3s_b = 1;
					~boo_p_rec1_3s_b = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec1_3s_b = {
					~p_rec1_3s_b.free; // stop play back
					~boo_p_rec1_3s_b = false;
					"playback stopped".postln;
					~countApcP_rec1_3s_b = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec1_3s_b = {
					m.noteOn(0, 23, 0); // light off
					~boo_p_rec1_3s_b = false;
					~countApcP_rec1_3s_b = 0;
				};

				/* press button p_rec1_3s_b */
				if (~countApcP_rec1_3s_b == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec1_3s_b = {
						~playbackStart_rec1_3s_b.();
						"on 23 button p_rec1_3s_b".postln;
						~bufLength_rec1_3s.yield; // time when playing back buffer
						if(~boo_p_rec1_3s_b, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec1_3s_b.();
							"off 23 button p_rec1_3s_b".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec1_3s_b == 1, {
						~playbackRout_rec1_3s_b.stop; // stop routine for sanity
						~playbackStop_rec1_3s_b.(); // call to stop recording and free buffer
						"off 23 button rec1_3s_b".postln;
						m.noteOn(0, 23, 0); // light off
					});
				});
			}, 23, srcID: ~apcID);

			/* playback rec1_5s*/
			MIDIdef.noteOn(\apcButton_p_rec1_5s, {
				arg vel, nn, chan, src;
				~playbackStart_rec1_5s = {
					m.noteOn(0, 18, 01); // light on
					/* playback */
					~p_rec1_5s = Ndef(\p_rec1_5s, ~playback_rec1_5s);
					Ndef(\p_rec1_5s).set(\bufnum, ~buf_rec1_5s);
					"playing p_rec1_5s".postln;
					~countApcP_rec1_5s = 1;
					~boo_p_rec1_5s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec1_5s = {
					~p_rec1_5s.free; // stop play back
					~boo_p_rec1_5s = false;
					"playback stopped".postln;
					~countApcP_rec1_5s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec1_5s = {
					m.noteOn(0, 18, 0); // light off
					~boo_p_rec1_5s = false;
					~countApcP_rec1_5s = 0;
				};

				/* press button p_rec1_5s */
				if (~countApcP_rec1_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec1_5s = {
						~playbackStart_rec1_5s.();
						"on 18 button p_rec1_5s".postln;
						~bufLength_rec1_5s.yield; // time when playing back buffer
						if(~boo_p_rec1_5s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec1_5s.();
							"off 18 button p_rec1_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec1_5s == 1, {
						~playbackRout_rec1_5s.stop; // stop routine for sanity
						~playbackStop_rec1_5s.(); // call to stop recording and free buffer
						"off 18 button rec1_5s".postln;
						m.noteOn(0, 18, 0); // light off
					});
				});
			}, 18, srcID: ~apcID);

			/* playback rec2_5s*/
			MIDIdef.noteOn(\apcButton_p_rec2_5s, {
				arg vel, nn, chan, src;
				~playbackStart_rec2_5s = {
					m.noteOn(0, 19, 01); // light on
					/* playback */
					~p_rec2_5s = Ndef(\p_rec2_5s, ~playback_rec2_5s);
					Ndef(\p_rec2_5s).set(\bufnum, ~buf_rec2_5s);
					"playing p_rec2_5s".postln;
					~countApcP_rec2_5s = 1;
					~boo_p_rec2_5s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec2_5s = {
					~p_rec2_5s.free; // stop play back
					~boo_p_rec2_5s = false;
					"playback stopped".postln;
					~countApcP_rec2_5s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec2_5s = {
					m.noteOn(0, 19, 0); // light off
					~boo_p_rec2_5s = false;
					~countApcP_rec2_5s = 0;
				};

				/* press button p_rec2_5s */
				if (~countApcP_rec2_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec2_5s = {
						~playbackStart_rec2_5s.();
						"on 19 button p_rec2_5s".postln;
						~bufLength_rec2_5s.yield; // time when playing back buffer
						if(~boo_p_rec2_5s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec2_5s.();
							"off 19 button p_rec2_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec2_5s == 1, {
						~playbackRout_rec2_5s.stop; // stop routine for sanity
						~playbackStop_rec2_5s.(); // call to stop recording and free buffer
						"off 19 button rec2_5s".postln;
						m.noteOn(0, 19, 0); // light off
					});
				});
			}, 19, srcID: ~apcID);

			/* playback rec3_5s*/
			MIDIdef.noteOn(\apcButton_p_rec3_5s, {
				arg vel, nn, chan, src;
				~playbackStart_rec3_5s = {
					m.noteOn(0, 20, 01); // light on
					/* playback */
					~p_rec3_5s = Ndef(\p_rec3_5s, ~playback_rec3_5s);
					Ndef(\p_rec3_5s).set(\bufnum, ~buf_rec3_5s);
					"playing p_rec3_5s".postln;
					~countApcP_rec3_5s = 1;
					~boo_p_rec3_5s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec3_5s = {
					~p_rec3_5s.free; // stop play back
					~boo_p_rec3_5s = false;
					"playback stopped".postln;
					~countApcP_rec3_5s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec3_5s = {
					m.noteOn(0, 20, 0); // light off
					~boo_p_rec3_5s = false;
					~countApcP_rec3_5s = 0;
				};

				/* press button p_rec3_5s */
				if (~countApcP_rec3_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec3_5s = {
						~playbackStart_rec3_5s.();
						"on 20 button p_rec3_5s".postln;
						~bufLength_rec3_5s.yield; // time when playing back buffer
						if(~boo_p_rec3_5s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec3_5s.();
							"off 20 button p_rec3_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec3_5s == 1, {
						~playbackRout_rec3_5s.stop; // stop routine for sanity
						~playbackStop_rec3_5s.(); // call to stop recording and free buffer
						"off 20 button rec3_5s".postln;
						m.noteOn(0, 20, 0); // light off
					});
				});
			}, 20, srcID: ~apcID);

			/* playback rec1_17s*/
			MIDIdef.noteOn(\apcButton_p_rec1_17s, {
				arg vel, nn, chan, src;
				~playbackStart_rec1_17s = {
					m.noteOn(0, 21, 01); // light on
					/* playback */
					~p_rec1_17s = Ndef(\p_rec1_17s, ~playback_rec1_17s);
					Ndef(\p_rec1_17s).set(\bufnum, ~buf_rec1_17s);
					"playing p_rec1_17s".postln;
					~countApcP_rec1_17s = 1;
					~boo_p_rec1_17s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec1_17s = {
					~p_rec1_17s.free; // stop play back
					~boo_p_rec1_17s = false;
					"playback stopped".postln;
					~countApcP_rec1_17s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec1_17s = {
					m.noteOn(0, 21, 0); // light off
					~boo_p_rec1_17s = false;
					~countApcP_rec1_17s = 0;
				};

				/* press button p_rec1_17s */
				if (~countApcP_rec1_17s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec1_17s = {
						~playbackStart_rec1_17s.();
						"on 21 button p_rec1_17s".postln;
						~bufLength_rec1_17s.yield; // time when playing back buffer
						if(~boo_p_rec1_17s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec1_17s.();
							"off 21 button p_rec1_17s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec1_17s == 1, {
						~playbackRout_rec1_17s.stop; // stop routine for sanity
						~playbackStop_rec1_17s.(); // call to stop recording and free buffer
						"off 21 button rec1_17s".postln;
						m.noteOn(0, 21, 0); // light off
					});
				});
			}, 21, srcID: ~apcID);

			/* playback rec2_4s*/
			MIDIdef.noteOn(\apcButton_p_rec2_4s, {
				arg vel, nn, chan, src;
				~playbackStart_rec2_4s = {
					m.noteOn(0, 0, 01); // light on
					/* playback */
					~p_rec2_4s = Ndef(\p_rec2_4s, ~playback_rec2_4s);
					Ndef(\p_rec2_4s).set(\bufnum, ~buf_rec2_4s);
					"playing p_rec2_4s".postln;
					~countApcP_rec2_4s = 1;
					~boo_p_rec2_4s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec2_4s = {
					~p_rec2_4s.free; // stop play back
					~boo_p_rec2_4s = false;
					"playback stopped".postln;
					~countApcP_rec2_4s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec2_4s = {
					m.noteOn(0, 0, 0); // light off
					~boo_p_rec2_4s = false;
					~countApcP_rec2_4s = 0;
				};

				/* press button p_rec2_4s */
				if (~countApcP_rec2_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec2_4s = {
						~playbackStart_rec2_4s.();
						"on 0 button p_rec2_4s".postln;
						~bufLength_rec2_4s.yield; // time when playing back buffer
						if(~boo_p_rec2_4s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec2_4s.();
							"off 0 button p_rec2_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec2_4s == 1, {
						~playbackRout_rec2_4s.stop; // stop routine for sanity
						~playbackStop_rec2_4s.(); // call to stop recording and free buffer
						"off 0 button rec2_4s".postln;
						m.noteOn(0, 0, 0); // light off
					});
				});
			}, 0, srcID: ~apcID);

			/* playback rec3_4s*/
			MIDIdef.noteOn(\apcButton_p_rec3_4s, {
				arg vel, nn, chan, src;
				~playbackStart_rec3_4s = {
					m.noteOn(0, 1, 01); // light on
					/* playback */
					~p_rec3_4s = Ndef(\p_rec3_4s, ~playback_rec3_4s);
					Ndef(\p_rec3_4s).set(\bufnum, ~buf_rec3_4s);
					"playing p_rec3_4s".postln;
					~countApcP_rec3_4s = 1;
					~boo_p_rec3_4s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec3_4s = {
					~p_rec3_4s.free; // stop play back
					~boo_p_rec3_4s = false;
					"playback stopped".postln;
					~countApcP_rec3_4s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec3_4s = {
					m.noteOn(0, 1, 0); // light off
					~boo_p_rec3_4s = false;
					~countApcP_rec3_4s = 0;
				};

				/* press button p_rec3_4s */
				if (~countApcP_rec3_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec3_4s = {
						~playbackStart_rec3_4s.();
						"on 1 button p_rec3_4s".postln;
						~bufLength_rec3_4s.yield; // time when playing back buffer
						if(~boo_p_rec3_4s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec3_4s.();
							"off 1 button p_rec3_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec3_4s == 1, {
						~playbackRout_rec3_4s.stop; // stop routine for sanity
						~playbackStop_rec3_4s.(); // call to stop recording and free buffer
						"off 1 button rec3_4s".postln;
						m.noteOn(0, 1, 0); // light off
					});
				});
			}, 1, srcID: ~apcID);

			/* playback rec4_4s*/
			MIDIdef.noteOn(\apcButton_p_rec4_4s, {
				arg vel, nn, chan, src;
				~playbackStart_rec4_4s = {
					m.noteOn(0, 2, 01); // light on
					/* playback */
					~p_rec4_4s = Ndef(\p_rec4_4s, ~playback_rec4_4s);
					Ndef(\p_rec4_4s).set(\bufnum, ~buf_rec4_4s);
					"playing p_rec4_4s".postln;
					~countApcP_rec4_4s = 1;
					~boo_p_rec4_4s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec4_4s = {
					~p_rec4_4s.free; // stop play back
					~boo_p_rec4_4s = false;
					"playback stopped".postln;
					~countApcP_rec4_4s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec4_4s = {
					m.noteOn(0, 2, 0); // light off
					~boo_p_rec4_4s = false;
					~countApcP_rec4_4s = 0;
				};

				/* press button p_rec4_4s */
				if (~countApcP_rec4_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec4_4s = {
						~playbackStart_rec4_4s.();
						"on 2 button p_rec4_4s".postln;
						~bufLength_rec4_4s.yield; // time when playing back buffer
						if(~boo_p_rec4_4s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec4_4s.();
							"off 2 button p_rec4_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec4_4s == 1, {
						~playbackRout_rec4_4s.stop; // stop routine for sanity
						~playbackStop_rec4_4s.(); // call to stop recording and free buffer
						"off 2 button rec4_4s".postln;
						m.noteOn(0, 2, 0); // light off
					});
				});
			}, 2, srcID: ~apcID);

			/* playback rec5_4s*/
			MIDIdef.noteOn(\apcButton_p_rec5_4s, {
				arg vel, nn, chan, src;
				~playbackStart_rec5_4s = {
					m.noteOn(0, 3, 01); // light on
					/* playback */
					~p_rec5_4s = Ndef(\p_rec5_4s, ~playback_rec5_4s);
					Ndef(\p_rec5_4s).set(\bufnum, ~buf_rec5_4s);
					"playing p_rec5_4s".postln;
					~countApcP_rec5_4s = 1;
					~boo_p_rec5_4s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec5_4s = {
					~p_rec5_4s.free; // stop play back
					~boo_p_rec5_4s = false;
					"playback stopped".postln;
					~countApcP_rec5_4s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec5_4s = {
					m.noteOn(0, 3, 0); // light off
					~boo_p_rec5_4s = false;
					~countApcP_rec5_4s = 0;
				};

				/* press button p_rec5_4s */
				if (~countApcP_rec5_4s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec5_4s = {
						~playbackStart_rec5_4s.();
						"on 3 button p_rec5_4s".postln;
						~bufLength_rec5_4s.yield; // time when playing back buffer
						if(~boo_p_rec5_4s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec5_4s.();
							"off 3 button p_rec5_4s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec5_4s == 1, {
						~playbackRout_rec5_4s.stop; // stop routine for sanity
						~playbackStop_rec5_4s.(); // call to stop recording and free buffer
						"off 3 button rec5_4s".postln;
						m.noteOn(0, 3, 0); // light off
					});
				});
			}, 3, srcID: ~apcID);

			/* playback rec1_22s_b*/
			MIDIdef.noteOn(\apcButton_p_rec1_22s_b, {
				arg vel, nn, chan, src;
				~playbackStart_rec1_22s_b = {
					m.noteOn(0, 4, 01); // light on
					/* playback */
					~p_rec1_22s_b = Ndef(\p_rec1_22s_b, ~playback_rec1_22s_b);
					Ndef(\p_rec1_22s_b).set(\bufnum, ~buf_rec1_22s);
					//Ndef(\p_rec1_22s_b).set(\rate, -1);
					"playing p_rec1_22s_b".postln;
					~countApcP_rec1_22s_b = 1;
					~boo_p_rec1_22s_b = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec1_22s_b = {
					~p_rec1_22s_b.free; // stop play back
					~boo_p_rec1_22s_b = false;
					"playback stopped".postln;
					~countApcP_rec1_22s_b = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec1_22s_b = {
					m.noteOn(0, 4, 0); // light off
					~boo_p_rec1_22s_b = false;
					~countApcP_rec1_22s_b = 0;
				};

				/* press button p_rec5_4s */
				if (~countApcP_rec1_22s_b == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec1_22s_b = {
						~playbackStart_rec1_22s_b.();
						"on 4 button p_rec1_22s_b".postln;
						~bufLength_rec1_22s.yield; // time when playing back buffer
						if(~boo_p_rec1_22s_b, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec1_22s_b.();
							"off 4 button p_rec1_22s_b".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec1_22s_b == 1, {
						~playbackRout_rec1_22s_b.stop; // stop routine for sanity
						~playbackStop_rec1_22s_b.(); // call to stop recording and free buffer
						"off 4 button rec1_22s_b".postln;
						m.noteOn(0, 4, 0); // light off
					});
				});
			}, 4, srcID: ~apcID);

			/* playback rec6_5s */
			MIDIdef.noteOn(\apcButton_p_rec6_5s, {
				arg vel, nn, chan, src;
				~playbackStart_rec6_5s = {
					m.noteOn(0, 22, 01); // light on
					/* playback */
					~p_rec6_5s = Ndef(\p_rec6_5s, ~playback_rec6_5s);
					Ndef(\p_rec6_5s).set(\bufnum, ~buf_rec6_5s);
					"playing p_rec6_5s".postln;
					~countApcP_rec6_5s = 1;
					~boo_p_rec6_5s = true; // boolean
				};
				/* stop recording and free buffer */
				~playbackStop_rec6_5s = {
					~p_rec6_5s.free; // stop play back
					~boo_p_rec6_5s = false;
					"playback stopped".postln;
					~countApcP_rec6_5s = 0;
				};
				/* function to turn light off after recording */
				~playbackCompleteLightOff_rec6_5s = {
					m.noteOn(0, 22, 0); // light off
					~boo_p_rec6_5s = false;
					~countApcP_rec6_5s = 0;
				};

				/* press button p_rec6_5s */
				if (~countApcP_rec6_5s == 0, {
					// routine to start recording and turn light off after recording is completed
					~playbackRout_rec6_5s = {
						~playbackStart_rec6_5s.();
						"on 22 button p_rec6_5s".postln;
						~bufLength_rec6_5s.yield; // time when playing back buffer
						if(~boo_p_rec6_5s, {
							"playback complete".postln;
							~playbackCompleteLightOff_rec6_5s.();
							"off 22 button p_rec6_5s".postln;
						});
					}.fork;
				}, {
					// stop in the middle of play back; press again off
					if (~countApcP_rec6_5s == 1, {
						~playbackRout_rec6_5s.stop; // stop routine for sanity
						~playbackStop_rec6_5s.(); // call to stop recording and free buffer
						"off 22 button rec6_5s".postln;
						m.noteOn(0, 22, 0); // light off
					});
				});
			}, 22, srcID: ~apcID);


			/****************************************** granular synth ******************************************/
			/* granularize recording rec1_17s */
			MIDIdef.noteOn(\apcButton6, {
				arg vel, nn, chan, src;
				/* granularize rec1_17s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec1_17s == 0, {
					~granularize_rec1_17s = Ndef(\granularize_rec1_17s, ~gran_rec1_17s);
					Ndef(\granularize_rec1_17s).set(\sndbuf, ~buf_rec1_17s);
					m.noteOn(0, 45, 01); //light on
					"on 45 button 6".postln;
					~countApcGran_rec1_17s = 1;
				}, {
					~granularize_rec1_17s.release(0);
					m.noteOn(0, 45, 0); //light off
					"off 45 button 6".postln;
					~countApcGran_rec1_17s = 0;
				});
			}, 45, srcID: ~apcID);

			/* granularize recording rec4_5s */
			MIDIdef.noteOn(\apcButton7, {
				arg vel, nn, chan, src;
				/* granularize rec4_5s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec4_5s == 0, {
					~granularize_rec4_5s = Ndef(\granularize_rec4_5s, ~gran_rec4_5s);
					Ndef(\granularize_rec4_5s).set(\sndbuf, ~buf_rec4_5s);
					m.noteOn(0, 46, 01); //light on
					"on 46 button 7".postln;
					~countApcGran_rec4_5s = 1;
				}, {
					~granularize_rec4_5s.release(0);
					m.noteOn(0, 46, 0); //light off
					"off 46 button 7".postln;
					~countApcGran_rec4_5s = 0;
				});
			}, 46, srcID: ~apcID);

			/* granularize recording rec5_5s */
			MIDIdef.noteOn(\apcButton8, {
				arg vel, nn, chan, src;
				/* granularize rec5_5s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec5_5s == 0, {
					~granularize_rec5_5s = Ndef(\granularize_rec5_5s, ~gran_rec5_5s);
					Ndef(\granularize_rec5_5s).set(\sndbuf, ~buf_rec5_5s);
					m.noteOn(0, 47, 01); //light on
					"on 47 button 8".postln;
					~countApcGran_rec5_5s = 1;
				}, {
					~granularize_rec5_5s.release(0);
					m.noteOn(0, 47, 0); //light off
					"off 47 button 8".postln;
					~countApcGran_rec5_5s = 0;
				});
			}, 47, srcID: ~apcID);

			/* granularize recording rec5_5s */
			MIDIdef.noteOn(\apcButton9, {
				arg vel, nn, chan, src;
				/* granularize rec1_4s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec1_4s == 0, {
					~granularize_rec1_4s = Ndef(\granularize_rec1_4s, ~gran_rec1_4s);
					Ndef(\granularize_rec1_4s).set(\sndbuf, ~buf_rec1_4s);
					m.noteOn(0, 32, 01); //light on
					"on 32 button 9".postln;
					~countApcGran_rec1_4s = 1;
				}, {
					~granularize_rec1_4s.release(0);
					m.noteOn(0, 32, 0); //light off
					"off 32 button 9".postln;
					~countApcGran_rec1_4s = 0;
				});
			}, 32, srcID: ~apcID);

			/* granularize recording rec1_22s */
			MIDIdef.noteOn(\apcButton10, {
				arg vel, nn, chan, src;
				/* granularize rec1_22s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec1_22s == 0, {
					~granularize_rec1_22s = Ndef(\granularize_rec1_22s, ~gran_rec1_22s);
					Ndef(\granularize_rec1_22s).set(\sndbuf, ~buf_rec1_22s);
					m.noteOn(0, 33, 01); //light on
					"on 33 button 10".postln;
					~countApcGran_rec1_22s = 1;
				}, {
					~granularize_rec1_22s.release(0);
					m.noteOn(0, 33, 0); //light off
					"off 33 button 10".postln;
					~countApcGran_rec1_22s = 0;
				});
			}, 33, srcID: ~apcID);

			/* granularize recording rec3_2s */
			MIDIdef.noteOn(\apcButton11, {
				arg vel, nn, chan, src;
				/* granularize rec3_2s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec3_2s == 0, {
					~granularize_rec3_2s = Ndef(\granularize_rec3_2s, ~gran_rec3_2s);
					Ndef(\granularize_rec3_2s).set(\sndbuf, ~buf_rec3_2s);
					m.noteOn(0, 34, 01); //light on
					"on 34 button 11".postln;
					~countApcGran_rec3_2s = 1;
				}, {
					~granularize_rec3_2s.release(0);
					m.noteOn(0, 34, 0); //light off
					"off 34 button 11".postln;
					~countApcGran_rec3_2s = 0;
				});
			}, 34, srcID: ~apcID);

			/* granularize recording rec6_4s */
			MIDIdef.noteOn(\apcButton12, {
				arg vel, nn, chan, src;
				/* granularize rec6_4s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec6_4s == 0, {
					~granularize_rec6_4s = Ndef(\granularize_rec6_4s, ~gran_rec6_4s);
					Ndef(\granularize_rec6_4s).set(\sndbuf, ~buf_rec6_4s);
					m.noteOn(0, 35, 01); //light on
					"on 35 button 12".postln;
					~countApcGran_rec6_4s = 1;
				}, {
					~granularize_rec6_4s.release(0);
					m.noteOn(0, 35, 0); //light off
					"off 35 button 12".postln;
					~countApcGran_rec6_4s = 0;
				});
			}, 35, srcID: ~apcID);

			/* granularize recording rec1_8s */
			MIDIdef.noteOn(\apcButton13, {
				arg vel, nn, chan, src;
				/* granularize rec1_8s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec1_8s == 0, {
					~granularize_rec1_8s = Ndef(\granularize_rec1_8s, ~gran_rec1_8s);
					Ndef(\granularize_rec1_8s).set(\sndbuf, ~buf_rec1_8s);
					m.noteOn(0, 36, 01); //light on
					"on 36 button 13".postln;
					~countApcGran_rec1_8s = 1;
				}, {
					~granularize_rec1_8s.release(0);
					m.noteOn(0, 36, 0); //light off
					"off 36 button 13".postln;
					~countApcGran_rec1_8s = 0;
				});
			}, 36, srcID: ~apcID);

			/* granularize recording rec2_8s */
			MIDIdef.noteOn(\apcButton14, {
				arg vel, nn, chan, src;
				/* granularize rec2_8s, control rate (frq mod), dur, density and pan */
				if (~countApcGran_rec2_8s == 0, {
					~granularize_rec2_8s = Ndef(\granularize_rec2_8s, ~gran_rec2_8s);
					Ndef(\granularize_rec2_8s).set(\sndbuf, ~buf_rec2_8s);
					m.noteOn(0, 37, 01); //light on
					"on 37 button 14".postln;
					~countApcGran_rec2_8s = 1;
				}, {
					~granularize_rec2_8s.release(0);
					m.noteOn(0, 37, 0); //light off
					"off 37 button 14".postln;
					~countApcGran_rec2_8s = 0;
				});
			}, 37, srcID: ~apcID);

			/* granularize input signal 0; button 5 on apc; midi 44 */
			MIDIdef.noteOn(\apcButton5, {
				arg vel, nn, chan, src;
				/* granularize signal from input 0 (mic 1) */
				if (~countApcGran_input0 == 0, {
					~granularize_in0 = Ndef(\granularize_in0, ~gran_in0);
					m.noteOn(0, 44, 01); //light on
					"on 44 button 5".postln;
					~countApcGran_input0 = 1;
				}, {
					~granularize_in0.release(1);
					m.noteOn(0, 44, 0); //light off
					"off 44 button 5".postln;
					~countApcGran_input0 = 0;
				});
			}, 44, srcID: ~apcID);

			/* 12 sec delay on input signal 0; button 15 on apc; midi 38 */
			MIDIdef.noteOn(\apcButton15, {
				arg vel, nn, chan, src;
				/* 12 sec delay signal from input 0 (mic 1) */
				if (~countApcDelay_12s_in0 == 0, {
					~delay_12s_in0 = Ndef(\delay_12s_in0, ~delay12sec_input0);
					m.noteOn(0, 38, 01); //light on
					"on 38 button 15".postln;
					~countApcDelay_12s_in0 = 1;
				}, {
					~delay_12s_in0.release(1);
					m.noteOn(0, 38, 0); //light off
					"off 38 button 15".postln;
					~countApcDelay_12s_in0 = 0;
				});
			}, 38, srcID: ~apcID);

			/* playback wind_low recording through sp 1357 */
			MIDIdef.noteOn(\apcButton1, {
				arg vel, nn, chan, src;
				/* playback wind_low recording through sp 1357, control panning and reverb */
				if (~countApcP_rec_wind_low_1357 == 0, {
					~p_rec_wind_low_1357 = Ndef(\p_rec_wind_low_1357, ~playback_rec_wind_low_1357);
					Ndef(\p_rec_wind_low_1357).set(\bufnum, ~buf_rec_wind_low);
					m.noteOn(0, 40, 01); //light on
					"on 40 button 1".postln;
					~countApcP_rec_wind_low_1357 = 1;
				}, {
					~p_rec_wind_low_1357.release(1);
					m.noteOn(0, 40, 0); //light off
					"off 40 button 1".postln;
					~countApcP_rec_wind_low_1357 = 0;
				});
			}, 40, srcID: ~apcID);

			/* playback wind_low recording through sp 2468 */
			MIDIdef.noteOn(\apcButton2, {
				arg vel, nn, chan, src;
				/* playback wind_low recording through sp 2468, control panning and reverb */
				if (~countApcP_rec_wind_low_2468 == 0, {
					~p_rec_wind_low_2468 = Ndef(\p_rec_wind_low_2468, ~playback_rec_wind_low_2468);
					Ndef(\p_rec_wind_low_2468).set(\bufnum, ~buf_rec_wind_low);
					m.noteOn(0, 41, 01); //light on
					"on 41 button 2".postln;
					~countApcP_rec_wind_low_2468 = 1;
				}, {
					~p_rec_wind_low_2468.release(1);
					m.noteOn(0, 41, 0); //light off
					"off 41 button 2".postln;
					~countApcP_rec_wind_low_2468 = 0;
				});
			}, 41, srcID: ~apcID);

			/* playback wind_high recording through sp 1357 */
			MIDIdef.noteOn(\apcButton3, {
				arg vel, nn, chan, src;
				/* playback wind_high recording through sp 1357, control panning and reverb */
				if (~countApcP_rec_wind_high_1357 == 0, {
					~p_rec_wind_high_1357 = Ndef(\p_rec_wind_high_1357, ~playback_rec_wind_high_1357);
					Ndef(\p_rec_wind_high_1357).set(\bufnum, ~buf_rec_wind_high);
					m.noteOn(0, 42, 01); //light on
					"on 42 button 3".postln;
					~countApcP_rec_wind_high_1357 = 1;
				}, {
					~p_rec_wind_high_1357.release(1);
					m.noteOn(0, 42, 0); //light off
					"off 42 button 3".postln;
					~countApcP_rec_wind_high_1357 = 0;
				});
			}, 42, srcID: ~apcID);

			/* playback wind_high recording through sp 2468 */
			MIDIdef.noteOn(\apcButton4, {
				arg vel, nn, chan, src;
				/* playback wind_high recording through sp 2468, control panning and reverb */
				if (~countApcP_rec_wind_high_2468 == 0, {
					~p_rec_wind_high_2468 = Ndef(\p_rec_wind_high_2468, ~playback_rec_wind_high_2468);
					Ndef(\p_rec_wind_high_2468).set(\bufnum, ~buf_rec_wind_high);
					m.noteOn(0, 43, 01); //light on
					"on 43 button 4".postln;
					~countApcP_rec_wind_high_2468 = 1;
				}, {
					~p_rec_wind_high_2468.release(1);
					m.noteOn(0, 43, 0); //light off
					"off 43 button 4".postln;
					~countApcP_rec_wind_high_2468 = 0;
				});
			}, 43, srcID: ~apcID);



			/****************************************** speaker test ******************************************/
			//////////////////// sweep/noise sp 1 //////////////////// button 01
			MIDIdef.noteOn(\apcButton64, {
				arg vel, nn, chan, src;
				if (~countApc01 == 0, {
					~sweep1 = Ndef(\sweep1, ~sweep_sp1);
					//Ndef(\sweep1).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep1).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 64, 01); //light on
					"on 64 button 01 sweep/noise speaker 1".postln;
					~countApc01 = 1;
				}, {
					~sweep1.release(1);
					m.noteOn(0, 64, 0); //light off
					"off 64 button 01".postln;
					~countApc01= 0;
				});
			}, 64, srcID: ~apcID);

			//////////////////// sweep/noise sp 2 //////////////////// button 02
			MIDIdef.noteOn(\apcButton65, {
				arg vel, nn, chan, src;
				if (~countApc02 == 0, {
					~sweep2 = Ndef(\sweep2, ~sweep_sp2);
					Ndef(\sweep2).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 65, 01); //light on
					"on 65 button 02 sweep/noise speaker 2".postln;
					~countApc02 = 1;
				}, {
					~sweep2.release(1);
					m.noteOn(0, 65, 0); //light off
					"off 65 button 02".postln;
					~countApc02 = 0;
				});
			}, 65, srcID: ~apcID);

			//////////////////// sweep/noise sp 3 //////////////////// button 03
			MIDIdef.noteOn(\apcButton66, {
				arg vel, nn, chan, src;
				if (~countApc03 == 0, {
					~sweep3 = Ndef(\sweep3, ~sweep_sp3);
					//Ndef(\sweep3).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep3).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 66, 01); //light on
					"on 66 button 03 sweep/noise speaker 3".postln;
					~countApc03 = 1;
				}, {
					~sweep3.release(1);
					m.noteOn(0, 66, 0); //light off
					"off 66 button 03".postln;
					~countApc03 = 0;
				});
			}, 66, srcID: ~apcID);

			//////////////////// sweep/noise sp 4 //////////////////// button 04
			MIDIdef.noteOn(\apcButton67, {
				arg vel, nn, chan, src;
				if (~countApc04 == 0, {
					~sweep4 = Ndef(\sweep4, ~sweep_sp4);
					//Ndef(\sweep4).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep4).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 67, 01); //light on
					"on 67 button 04 sweep/noise speaker 4".postln;
					~countApc04 = 1;
				}, {
					~sweep4.release(1);
					m.noteOn(0, 67, 0); //light off
					"off 67 button 04".postln;
					~countApc04 = 0;
				});
			}, 67, srcID: ~apcID);

			//////////////////// sweep/noise sp 5 //////////////////// button 05
			MIDIdef.noteOn(\apcButton68, {
				arg vel, nn, chan, src;
				if (~countApc05 == 0, {
					~sweep5 = Ndef(\sweep5, ~sweep_sp5);
					//Ndef(\sweep5).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep5).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 68, 01); //light on
					"on 68 button 05 sweep/noise speaker 5".postln;
					~countApc05 = 1;
				}, {
					~sweep5.release(1);
					m.noteOn(0, 68, 0); //light off
					"off 68 button 05".postln;
					~countApc05 = 0;
				});
			}, 68, srcID: ~apcID);

			//////////////////// sweep/noise sp 6 //////////////////// button 06
			MIDIdef.noteOn(\apcButton69, {
				arg vel, nn, chan, src;
				if (~countApc06 == 0, {
					~sweep6 = Ndef(\sweep6, ~sweep_sp6);
					//Ndef(\sweep6).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep6).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 69, 01); //light on
					"on 69 button 06 sweep/noise speaker 6".postln;
					~countApc06 = 1;
				}, {
					~sweep6.release(1);
					m.noteOn(0, 69, 0); //light off
					"off 69 button 06".postln;
					~countApc06 = 0;
				});
			}, 69, srcID: ~apcID);

			//////////////////// sweep/noise sp 7 //////////////////// button 07
			MIDIdef.noteOn(\apcButton70, {
				arg vel, nn, chan, src;
				if (~countApc07 == 0, {
					~sweep7 = Ndef(\sweep7, ~sweep_sp7);
					//Ndef(\sweep7).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep7).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 70, 01); //light on
					"on 70 button 07 sweep/noise speaker 7".postln;
					~countApc07 = 1;
				}, {
					~sweep7.release(1);
					m.noteOn(0, 70, 0); //light off
					"off 70 button 07".postln;
					~countApc07 = 0;
				});
			}, 70, srcID: ~apcID);

			//////////////////// sweep/noise sp 8 //////////////////// button 08
			MIDIdef.noteOn(\apcButton71, {
				arg vel, nn, chan, src;
				if (~countApc08 == 0, {
					~sweep8 = Ndef(\sweep8, ~sweep_sp8);
					//Ndef(\sweep8).set(\bufnum, ~bufTestSweep);
					Ndef(\sweep8).set(\bufnum, ~bufTestNoise);
					m.noteOn(0, 71, 01); //light on
					"on 71 button 08 sweep/noise speaker 8".postln;
					~countApc08 = 1;
				}, {
					~sweep8.release(1);
					m.noteOn(0, 71, 0); //light off
					"off 71 button 08".postln;
					~countApc08 = 0;
				});
			}, 71, srcID: ~apcID);


		};



		/* run mappings for controllers, and send on and off messages */
		//  go APC mapping
		~midiMapApc.();

		"midiMap done".postln;

		"done!".postln;
	};
}.fork

)

//////////////////////////////////////// END ////////////////////////////////////////




