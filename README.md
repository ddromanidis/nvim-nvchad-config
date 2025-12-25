# Moving from custom nvim config to distribution

For couple of years I've been using a custom nvim config, which mostly consisted of 
copy-pasted code from here and there. As I opted for Neovim, which is still in development
and has yet to reach v1.0.0, maintaining own setting becomes somewhat taxing. Therefore I
made a choice to move to community maintained distribution of Neovim configuration.

I found NVchad appealing to an eye and holding most functionality I need, with not much
configuration needed from my side. Nevertheless, I had to swap keys and add few loc, which
is why I am putting it up on GH.

Check out NVchad:
<https://github.com/NvChad/NvChad> https://github.com/NvChad/NvChad

**This repo is supposed to be used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
