#------------------------------------------------------------------------------
# Custom Shell Functions
#------------------------------------------------------------------------------

# Compresses a file or directory into a .tar.gz archive.
# Usage: compress <file_or_directory>
compress() {
  if [ -z "$1" ]; then
    echo "Usage: compress <file_or_directory>"
    return 1
  fi
  tar -czf "${1%/}.tar.gz" "${1%/}"
}

# Converts a .webm video file to .mp4 using ffmpeg.
# Requires ffmpeg to be installed.
# Usage: webm2mp4 <input_file.webm>
webm2mp4() {
  if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg not found! Please install it to use this function." >&2
    return 1
  fi
  if [ -z "$1" ]; then
    echo "Usage: webm2mp4 <input_file.webm>"
    return 1
  fi
  local input_file="$1"
  local output_file="${input_file%.webm}.mp4"
  ffmpeg -i "$input_file" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k "$output_file"
}

# Wraps the pokemon-colorscripts command to make it optional.
# Can be called manually or placed in .zshrc to run on startup.
run_pokemon_fastfetch() {
  if command -v pokemon-colorscripts &> /dev/null && command -v fastfetch &> /dev/null; then
    pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
  else
    echo "pokemon-colorscripts or fastfetch not found."
  fi
}
