{
  programs.wofi = {
    enable = true;

    settings = {
      allow_images = true;
      allow_markup = true;
      gtk-dark = true;
      image_size = 32;
      matching = "multi-contains";
      insensitive = true;
      term = "foot";
    };

    style = ''
      #outer-box {
        border-width: 2px;
        border-style: solid;
        border-color: --wofi-color5;
      }

      #img {
        padding-right: 8px;
      }

      #entry:selected {
        border-radius: 0;
      }
    '';
  };
}
