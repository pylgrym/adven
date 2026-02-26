function makeSoundFileName(txt) {
    let reduc = txt.toLowerCase(); // Remove special characters and spaces, replace with underscores
    reduc = reduc.replaceAll(/[^a-z]+/g, ' ').trim();
    //console.log('saundName:', reduc);
    reduc = reduc.replaceAll(' ', '_'); // Replace spaces with underscores
    reduc = reduc.substring(0, 50); // Limit to 20 characters
    //console.log('siundName:', reduc);
    reduc = 'sounds/out/' + reduc + '.mp3'; // Add file extension
    //console.log('soundName:', reduc);
    return reduc;
}

async function speak1(txt) {
    let soundName  = makeSoundFileName(txt);
    const audio = new Audio(soundName);
    try {
        //await audio.play();
        await new Promise((resolve, reject) => {
            audio.addEventListener('ended', resolve);
            audio.addEventListener('error', reject);
            audio.play().catch(reject);
        });
    } catch (e) {
        console.warn('this sound was a bummer:', e, soundName,txt);
    }
    return;

    /*
    DOMException: The play method is not allowed by the user agent or the platform in the current context,
    possibly because the user denied permission.
     */

    //txt = txt.replace(/·/g, ' ')
    return new Promise((resolve, reject) => {

        const msg = new SpeechSynthesisUtterance();
        //msg.onboundary = onBoundary; // callback
        msg.text = txt;
        msg.lang = 'en-UK';
        msg.rate = 0.9; //0.5; //0.75; // we need it slower when we want to follow what is being said.

        const voices = speechSynthesis.getVoices(); // Load voices asynchronously (important!)
        //console.log('#voices:', voices.length);

        diagnostic(msg,voices,txt); //if (!) { return; }

        msg.onend = () => resolve();
        msg.onerror = (e) => reject(e);

        window.speechSynthesis.speak(msg);
  });
}//speak1

function diagnostic(msg,voices,txt) {
    if (voices.length === 0) { // voices not loaded yet — wait a bit and try again
      console.log('no-voices-yet',txt);
      return false;
    }

    const filtered = voices.filter(v=>v.lang.startsWith('en'));
    console.log('en matches:', filtered.length);

    let enVoice = voices.find(v => v.lang.startsWith('en')); // Try to find a Japanese voice
    enVoice = filtered[1];
    if (enVoice) {
      msg.voice = enVoice;
      //console.log('we have en voice');
    } else {
      console.log('no en voice');
    }

    return true;
}

// Now you can await it
async function runDialogue() {
  await speak1("Welcome, traveller.");
  //await speak1("Who are you?");
  //await speak1("A friend.");
}
//runDialogue();

function speak3(txt) {
  console.log('txt?', txt);
  const msg = new SpeechSynthesisUtterance();
  msg.text = txt;
  window.speechSynthesis.speak(msg);
}



function speak4(text, options = {}) {
  return new Promise((resolve, reject) => {
    const msg = new SpeechSynthesisUtterance(text);

    // Optional settings
    msg.voice = options.voice ?? null;
    msg.rate = options.rate ?? 1;
    msg.pitch = options.pitch ?? 1;
    msg.volume = options.volume ?? 1;

    msg.onend = () => resolve();
    msg.onerror = (e) => reject(e);

    window.speechSynthesis.speak(msg);
  });
}
