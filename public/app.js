const editor = ace.edit("editor");
editor.session.setMode("ace/mode/yaml");
editor.setValue(`rules:
  - id: com.foo.rule1
    pattern: Github
    message: Github -> GitHub
    fail: Github
    pass: GitHub
`);

document.querySelector("#test").addEventListener("click", async () => {
  const body = new FormData();
  body.append("config", editor.getValue());
  const response = await fetch("/test", { method: "POST", body });
  switch (response.status) {
    case 200:
      alert("OK!");
      break;
    case 400:
      const error = await response.text();
      alert(error);
      break;
    default:
      alert("Ooops!");
      break;
  }
});
