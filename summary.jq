def esc: tostring | gsub("[\r\n]+"; " ") | gsub("\\|"; "\\|") | gsub("<"; "\\<") | gsub("`"; "\\`");
.[]
| (.path | esc) as $p
| (.software.name // "-" | esc) as $n
| (if .version then "\(.version.version) (\(.version.platform))" else "-" end | esc) as $v
| (if .file.source then "\(.file.source.kind) (\(.file.source.host))" else "-" end | esc) as $s
| "| \($p) | \(if .found then "yes" else "no" end) | \($n) | \($v) | \($s) |"
