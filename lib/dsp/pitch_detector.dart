import 'dart:math';
class PitchResult{ final double freq; final double snr; final bool reliable; PitchResult(this.freq,this.snr,this.reliable); }
class Note{ final String name; final int octave; final double ref; final double cents; Note(this.name,this.octave,this.ref,this.cents); String get label=>"${name}${octave}";
  static Note fromFreq(double f,{double a4=440}){ final n=12*(log(f/a4)/ln2)+69; final k=n.round(); final names=['C','C#','D','D#','E','F','F#','G','G#','A','A#','B']; final name=names[k%12]; final octave=(k~/12)-1; final ref=a4*pow(2,(k-69)/12); final cents=1200*(log(f/ref)/ln2); return Note(name,octave,ref,cents); } }
class PitchDetector{
  final int fs; final int n;
  PitchDetector(this.fs,this.n);
  PitchResult process(List<double> x){
    // simple window + ACF peak + SNR
    final w=List<double>.generate(n,(i)=>x[i]*(0.5-0.5*cos(2*pi*i/(n-1))));
    // FFT-based autocorr (very compact approximation)
    int minLag=(fs/1200).floor(), maxLag=(fs/50).floor(); double best=0; int bestLag=-1;
    for(int lag=minLag; lag<maxLag && lag<n; lag++){ double s=0; for(int i=0;i<n-lag;i++){ s+=w[i]*w[i+lag]; } if(s>best){ best=s; bestLag=lag; } }
    if(bestLag<=0) return PitchResult(-1,0,false);
    final f0=fs/bestLag;
    // crude SNR: energy near harmonics vs rest
    double sig=0, noise=1e-9;
    for(int i=0;i<n;i++){ final t=i/fs; final v=w[i]; final ph=(2*pi*f0*t)% (2*pi); final near = (ph<0.3 || ph>2*pi-0.3); if(near) sig+=v*v; else noise+=v*v; }
    final snr=sig/noise; final reliable=snr>5;
    return PitchResult(f0,snr,reliable);
  }
}
