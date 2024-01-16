import json
import time

from datetime import datetime, UTC

with open("tarok/lib/internationalization/languages.dart", "r") as f:
    content = f.read()
    content = content.split("};")[0]
    find = "Map<String, Map<String, String>> get keys => "
    s = content.find(find) + len(find)
    content = content[s:] + "}"
    content = content.replace("\n", "")
    content = content.replace("  ", "")
    content = content.replace(",}", "}")
    content = content.replace("//", "")
    print(content)
    c = json.loads(content)
    
languages = list(c.keys())
print(languages)

language_options = ""
for i in languages:
    language_options += f'<option value="{i}">{i}</option>'
language_options += f'<option value="newlang">New language</option>'

# ja, vem, da je vulnerable za code injection, ampak to ni tako pomembna zadeva
# poleg tega, to ne bo gosteno na domeni palčke, temveč na github.io, kjer ljudje niso prijavljeni
html = f"""
<!DOCTYPE html>
<html>
<head>
<title>Palčka translation/localization tool</title>
<style>
.wrap {{
    width: 100%;
    display: flex;
}}

.floatleft {{
    flex: 1;
}}

.floatmiddle {{
    flex: 1;
}}

.floatright {{
    flex: 1;
}}

.translation {{
    min-height: 50px;
    padding: 2.5px;
    width: 95%;
    background-color: lightgrey;
}}

.trans-id {{
    min-height: 65px;
    width: 95%;
    background-color: lightgrey;
}}

textarea {{
    width: 100%;
    min-height: 50px;
}}

pre {{
    white-space: pre-wrap;
    overflow-wrap: anywhere;
    background: hsl(30,80%,90%);
}}
</style>

<script>
const languages = {json.dumps(c)};

let keys = "";

function makeHTML(h, editable) {{
    let k = "";
    let o = Object.keys(h);
    for (let i = 0; i < o.length; i++) {{
        let key = o[i];
        let value = h[key];
        k += '<div class="translation"><textarea id="' + (editable ? key : '') + '"' + (!editable ? 'disabled' : '') + '>' + value + '</textarea></div>'
    }}
    return k;
}}

function makeIDHTML(h) {{
    let k = "";
    let o = Object.keys(h);
    for (let i = 0; i < o.length; i++) {{
        let key = o[i];
        let value = h[key];
        k += '<div class="trans-id"><b>' + key + '</b></div>'
    }}
    return k;
}}

function selectLanguage() {{
    console.log("Calling selectLanguage");

    let enUS = JSON.parse(JSON.stringify(languages.en_US));
    let translated = JSON.parse(JSON.stringify(languages.en_US));

    let o2 = Object.keys(translated);
    for (let i = 0; i < o2.length; i++) {{
        translated[o2[i]] = "";
    }}

    let e = document.getElementById("language_select_html");
    var value = e.options[e.selectedIndex].value;
    console.log(value);
    if (languages[value] !== undefined) {{
        let o = Object.keys(languages[value]);
        for (let i = 0; i < o.length; i++) {{
            let key = o[i];
            let v = languages[value][key];
            translated[key] = v;
        }}
    }}

    document.getElementById("translate_from").innerHTML = makeHTML(enUS, false);
    document.getElementById("translate_to").innerHTML = makeHTML(translated, true);
    document.getElementById("translate_from_ids").innerHTML = makeIDHTML(enUS);
}}

function submit() {{
    let enUS = JSON.parse(JSON.stringify(languages.en_US));
    let o2 = Object.keys(enUS);
    for (let i = 0; i < o2.length; i++) {{
        enUS[o2[i]] = document.getElementById(o2[i]).value;
    }}
    document.getElementById("dumped_json").innerHTML = JSON.stringify(enUS);
}}
</script>

</head>

<body>
    <h1>Palčka internationalization utility</h1>

    Utility autogenerated from Palčka source code on {datetime.fromtimestamp(time.time(), UTC).strftime('%d. %m. %Y, %H.%M.%S')} UTC.

    <hr>

    Words with at symbols (such as @text) should not be translated.

    <p></p>

    <div class="wrap">
        <div class="floatleft">
            <select>
                <option value="ids">Internal identification symbols</option>
            </select>
            <p></p>
            <div id="translate_from_ids"></div>
        </div>
        <div class="floatmiddle">
            <select name="from_language" id="from_language">
                <option value="en-US">English (US)</option>
            </select>
            <p></p>
            <div id="translate_from"></div>
        </div>
        <div class="floatright">
            <select name="language_select_html" id="language_select_html" onchange="selectLanguage()">
{language_options}
            </select>
            <p></p>
            <div id="translate_to"></div>
        </div>
    </div>

    <p></p>

    <button onclick="submit()">Export</button>

    <p></p>

    Please send (copy & paste) the following text over to the developer on Discord (@mytja) or through email <a href="mailto:info@palcka.si">info@palcka.si</a> alongside the respective language name.

    Thank you so much for your contribution.

    <p></p>

    <pre id="dumped_json" style="width:98vw;"></pre>

    <p></p>
</body>

<script>
selectLanguage();
</script>

</html>
"""

with open("translation/index.html", "w+") as f:
    f.write(html)