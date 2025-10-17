#!/usr/bin/env bash
# checkenc.sh  用法：./checkenc.sh file1 file2 …
for f; do
    [[ -f $f ]] || { echo "跳过：$f 不是普通文件"; continue; }

    # 1. 用 file 看 MIME 描述，里面会带 charset 和 line terminator
    mime=$(file -b --mime-encoding "$f")      # 只取编码部分
    lineinfo=$(file -b "$f")                  # 整行描述，含 "with CRLF line terminators" 等

    # 2. 用 uchardet 再确认一次编码（比 file 更准，尤其中文）
    guessed=$(uchardet "$f")

    # 3. 判断换行符
    if   grep -q $'\r$' "$f" && grep -q $'\r\n$' "$f"; then
        eol="CRLF (Windows)"
    elif grep -q $'\r$' "$f" && ! grep -q $'\n' "$f"; then
        eol="CR (老 Mac)"
    else
        eol="LF (Unix)"
    fi

    # 4. 输出结果
    printf '%-30s 编码(file)=%-12s 编码(uchardet)=%-12s 换行=%s\n' \
           "$f" "$mime" "$guessed" "$eol"
done
