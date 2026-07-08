function background -d "Returns dark or light background"
    set bg (xrdb -query | sed -r -n 's/^st.background:[\\s\\t]+//p' | cut -d ':' -f 2 | sed -r 's/([0-9a-fA-F]+)/0x\1/g' | tr '/' '+' | math)
    set fg (xrdb -query | sed -r -n 's/^st.foreground:[\\s\\t]+//p' | cut -d ':' -f 2 | sed -r 's/([0-9a-fA-F]+)/0x\1/g' | tr '/' '+' | math)

    if test $bg -lt $fg
        echo "dark"
    else
        echo "light"
    end

end
