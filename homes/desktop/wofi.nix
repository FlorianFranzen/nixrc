{
  home.file.".config/wofi/config".text = ''
    allow_images=true
    allow_markup=true
    gtk-dark=true
    image_size=32
    matching=multi-contains
    insensitive=true
    term=foot
  '';

  home.file.".config/wofi/style.css".text = ''
    #outer-box {
      border-width: 1px;
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
}
