# music-related-projects

# Pitch Recognition with MATLAB

This MATLAB script performs pitch recognition on a given audio file containing musical notes. The script identifies individual notes, extracts their frequency information, and recognizes the corresponding pitch and octave. Additionally, a helper function is included to parse the input data into distinct note windows.

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/yourusername/your-repository.git
```

2. Ensure you have MATLAB installed on your system.

3. Place your audio file (e.g., `piano_A0.wav`) in the same directory as the script.

4. Open the script in MATLAB.

5. Modify the script to use your audio file:

```matlab
[data, Fs] = audioread('your_audio_file.wav');
```

## Running the Script

Execute the script in MATLAB to perform pitch recognition on the provided audio file. The script will display the recognized pitches and octaves for each note in the console.

```matlab
run your_script_name.m
```

## Script Overview

- The script begins by reading the audio file and obtaining note windows using the `notewindows` function.

- It then iterates through each note, performs Fast Fourier Transform (FFT) to extract frequency information, and filters out noisy notes.

- The `noteparse` function is utilized to find division points between distinct notes.

- Finally, the `findpitch` function is employed to recognize the pitch and octave of each note based on its frequency.

## Functions

### `noteparse`

```matlab
divs = noteparse(data);
```

This function takes a double array `data` as input and outputs a vector of division points representing the start and end of individual notes.

### `notewindows`

```matlab
w = notewindows(data);
```

A wrapper function for `noteparse` that returns the midpoint of the end and beginning points of each note window.

### `findpitch`

```matlab
[pitch, octave] = findpitch(freq);
```

Given a frequency `freq`, this function returns the musical pitch and its octave relative to the octave above middle C.

## Note

- Ensure that your audio file is in the acceptable frequency range for accurate pitch recognition (between 20 Hz and 20,000 Hz).

- The script may need further adjustments based on your specific use case or audio characteristics.

Feel free to explore and adapt the script for your own projects!
