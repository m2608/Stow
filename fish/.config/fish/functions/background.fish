function background -d "Returns dark or light background"
    set bg (xrdb -get "st.background" | cut -d ':' -f 2 | sed -r 's/([0-9a-fA-F]+)/0x\1/g' | tr '/' '+' | math)
    set fg (xrdb -get "st.foreground" | cut -d ':' -f 2 | sed -r 's/([0-9a-fA-F]+)/0x\1/g' | tr '/' '+' | math)

    if test $bg -lt $fg
        echo "dark"
    else
        echo "light"
    end

end
