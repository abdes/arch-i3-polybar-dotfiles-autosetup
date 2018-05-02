#!/bin/sh

for layout in ~/.config/i3/layouts/*; do
	i3-msg "workspace $(basename "$layout" .json); append_layout $layout"
done

(termite --role DevMain &)
(urxvt -name URxvt.DevSide-1 &)
(urxvt -name URxvt.DevSide-2 &)
(urxvt -name URxvt.DevSide-3 &)
(code &)
(firefox &)
