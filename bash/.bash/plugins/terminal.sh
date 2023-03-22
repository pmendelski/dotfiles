#!/usr/bin/env bash

terminal_test() {
  echo ">>> True color:"
  awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
  }'

  echo -e "\n>>> Basic formatting:"
  echo -e "\e[1mbold\e[0m"
  echo -e "\e[3mitalic\e[0m"
  echo -e "\e[3m\e[1mbold italic\e[0m"
  echo -e "\e[4munderline\e[0m"
  echo -e "\e[4:3mundercurl\e[0m"
  echo -e "\e[9mstrikethrough\e[0m"

  echo -e "\n>>> Underlines:"
  echo -e "\e[4mstraight underline (backwards compat)\e[0m"
  echo -e "\e[4:0mno underline\e[0m"
  echo -e "\e[4:1mstraight underline\e[0m"
  echo -e "\e[4:2mdouble underline\e[0m"
  echo -e "\e[4:3mcurly underline\e[0m"
  echo -e "\e[4:4mdotted underline\e[0m"
  echo -e "\e[4:5mdashed underline\e[0m"

  echo -e "\n>>> Color underlines:"
  echo -e "\e[4:1m\e[58:2:206:134:51mcolored straight underline\e[0m"
  echo -e "\e[4:2m\e[58:2:206:134:51mcolored double underline\e[0m"
  echo -e "\e[4:3m\e[58:2:206:134:51mcolored curly underline\e[0m"
  echo -e "\e[4:4m\e[58:2:206:134:51mcolored dotted underline\e[0m"
  echo -e "\e[4:5m\e[58:2:206:134:51mcolored dashed underline\e[0m"

  echo -e "\n>>> Basic text colors"
  echo -e "\e[0;31mRed Text\e[0m"
  echo -e "\e[0;32mGreen Text\e[0m"
  echo -e "\e[0;33mOrange Text\e[0m"
  echo -e "\e[0;34mBlue Text\e[0m"
  echo -e "\e[0;35mPurple Text\e[0m"
  echo -e "\e[0;36mCyan Text\e[0m"

  echo -e "\n>>> Color basic formatting:"
  echo -e "\e[1;32mbold\e[0m"
  echo -e "\e[3;32mitalic\e[0m"
  echo -e "\e[3m\e[1;32mbold italic\e[0m"
  echo -e "\e[4;32munderline\e[0m"
  echo -e "\e[4:3;32mundercurl\e[0m"
  echo -e "\e[9;32mstrikethrough\e[0m"

  echo -e "\n>>> Nerd Icons:"
  printf "Github: \uea84\n"
  printf "Docker: \ue7b0\n"
}
