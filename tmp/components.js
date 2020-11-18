(function(){
	var data={filePreview:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (file) {if (file.type.startsWith('image/')) {
pug_html = pug_html + "\u003Cdiv class=\"card flat loading\"\u003E\u003Cdiv class=\"avatar img\"\u003E\u003C\u002Fdiv\u003E\u003Cdiv class=\"truncate\"\u003E" + (pug.escape(null == (pug_interp = file.name) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
else {
pug_html = pug_html + "\u003Cdiv class=\"card flat\"\u003E\u003Cdiv class=\"truncate\"\u003E" + (pug.escape(null == (pug_interp = file.name) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}}.call(this,"file" in locals_for_with?locals_for_with.file:typeof file!=="undefined"?file:undefined));;return pug_html;},_:(function(){var e;return e=document.createElement("div"),function(r,t,i){var n,s,o,p;if(!(s=this[r]))throw"Unknown component: "+r;for(o=Array.isArray(t)?t.map(s).join(""):s(t),i&&(o=o.repeat(i)),e.innerHTML=o,p=e.childNodes,n=document.createDocumentFragment();p.length;)n.appendChild(p[0]);return n}})()};
	if(typeof Core.html=='object' && Core.html) Object.assign(Core.html, data);
	else Core.html=data;
})();