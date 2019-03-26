function colours() {
  for i in {0..15}; do
    for j in {0..15}; do
      k=$((j*16+i))

      printf "\x1b[38;5;${k}m%-11s" "colour${k}"
    done
    printf "\n"
  done
}

alias colors="colours"
