(function(){
	var data={filePreview:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (file) {if (file.type.startsWith('image/')) {
pug_html = pug_html + "\u003Cdiv class=\"card flat r loading f-col\"\u003E\u003Cspan class=\"close abs bg-default c-circle\" d-click=\"rmFile\"\u003E×\u003C\u002Fspan\u003E\u003Cdiv class=\"w-loading grow1 f-c\"\u003E\u003Ci class=\"ico t-4xl rotate\"\u003E\u003C\u002Fi\u003E\u003C\u002Fdiv\u003E\u003Cdiv class=\"h-loading grow1 img\"\u003E\u003C\u002Fdiv\u003E\u003Cdiv class=\"truncate pt\"\u003E" + (pug.escape(null == (pug_interp = file.name) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
else {
pug_html = pug_html + "\u003Cdiv class=\"card flat if-y m2\"\u003E\u003Cdiv class=\"truncate pt grow1\"\u003E" + (pug.escape(null == (pug_interp = file.name) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E\u003Cspan class=\"close\" d-click=\"rmFile\"\u003E×\u003C\u002Fspan\u003E\u003C\u002Fdiv\u003E";
}}.call(this,"file" in locals_for_with?locals_for_with.file:typeof file!=="undefined"?file:undefined));;return pug_html;},inputRange:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (Math, attrs, input) {pug_html = pug_html + "\u003Cinput" + (pug.attrs(pug.merge([{"class": "hidden","type": "range"},input]), false)) + "\u002F\u003E\u003Cdiv class=\"input-range progress sm\" d-click=\"select\" d-move=\"drag\" d-movestart=\"drag\" d-moveend=\"drag\"\u003E\u003Cdiv" + (" class=\"track\""+pug.attr("style", pug.style(`width: ${attrs.track}%`), true, false)) + "\u003E\u003Cdiv class=\"caret\"\u003E\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
if (attrs.step > 0) {
var p= Math.round((attrs.max-attrs.min)/attrs.step);
p= 100/p;
var st= p
while (st<100) {
pug_html = pug_html + "\u003Ci" + (" class=\"step\""+pug.attr("style", pug.style(`left: ${st}%`), true, false)) + "\u003E\u003C\u002Fi\u003E";
st+= p;
}
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";}.call(this,"Math" in locals_for_with?locals_for_with.Math:typeof Math!=="undefined"?Math:undefined,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined,"input" in locals_for_with?locals_for_with.input:typeof input!=="undefined"?input:undefined));;return pug_html;},inputRating:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (Array, Math, attrs, bIcon, icon, input, oldHTML) {pug_html = pug_html + "\u003Cinput" + (pug.attrs(pug.merge([{"class": "hidden","type": "range"},input]), false)) + "\u002F\u003E";
if (icon) {
var t= attrs.fix? oldHTML : Array(attrs.max - attrs.min).fill(icon).join(bIcon);
pug_html = pug_html + "\u003Cdiv" + (pug.attr("class", pug.classes(["input-range","input-rating",attrs.className], [false,false,true]), false, false)+" d-click=\"select\" d-move=\"drag\" d-movestart=\"drag\" d-moveend=\"drag\"") + "\u003E\u003Cdiv class=\"t-light\"\u003E" + (null == (pug_interp = t) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003Cdiv" + (" class=\"abs track\""+pug.attr("style", pug.style(`width: ${attrs.track}%`), true, false)) + "\u003E" + (null == (pug_interp = t) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
else {
pug_html = pug_html + "\u003Cdiv" + (pug.attr("class", pug.classes(["input-range","progress","sm",attrs.className], [false,false,false,true]), false, false)+" d-click=\"select\" d-move=\"drag\" d-movestart=\"drag\" d-moveend=\"drag\"") + "\u003E\u003Cdiv" + (" class=\"track\""+pug.attr("style", pug.style(`width: ${attrs.track}%`), true, false)) + "\u003E\u003C\u002Fdiv\u003E";
if (attrs.step > 0) {
var p= Math.round((attrs.max - attrs.min) / attrs.step);
p= 100/p;
var st= p
while (st < 100) {
pug_html = pug_html + "\u003Ci" + (" class=\"step\""+pug.attr("style", pug.style(`left: ${st}%`), true, false)) + "\u003E\u003C\u002Fi\u003E";
st+= p;
}
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";
}}.call(this,"Array" in locals_for_with?locals_for_with.Array:typeof Array!=="undefined"?Array:undefined,"Math" in locals_for_with?locals_for_with.Math:typeof Math!=="undefined"?Math:undefined,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined,"bIcon" in locals_for_with?locals_for_with.bIcon:typeof bIcon!=="undefined"?bIcon:undefined,"icon" in locals_for_with?locals_for_with.icon:typeof icon!=="undefined"?icon:undefined,"input" in locals_for_with?locals_for_with.input:typeof input!=="undefined"?input:undefined,"oldHTML" in locals_for_with?locals_for_with.oldHTML:typeof oldHTML!=="undefined"?oldHTML:undefined));;return pug_html;},gridHolder:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (h, w, x, y) {pug_html = pug_html + "\u003Cdiv" + (" class=\"_gridjs-holder\""+pug.attr("style", pug.style(`width: ${w}px; height: ${h}px; left: ${x}px; top: ${y}px`), true, false)) + "\u003E\u003C\u002Fdiv\u003E";}.call(this,"h" in locals_for_with?locals_for_with.h:typeof h!=="undefined"?h:undefined,"w" in locals_for_with?locals_for_with.w:typeof w!=="undefined"?w:undefined,"x" in locals_for_with?locals_for_with.x:typeof x!=="undefined"?x:undefined,"y" in locals_for_with?locals_for_with.y:typeof y!=="undefined"?y:undefined));;return pug_html;},alert:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (html, ok, state, text) {pug_html = pug_html + "\u003Cdiv" + (pug.attr("class", pug.classes(["modal",state], [false,true]), false, false)) + "\u003E\u003Cdiv" + (pug.attr("class", pug.classes(["modal-body","c-xs","card","p","mw-y","r",state], [false,false,false,false,false,false,true]), false, false)) + "\u003E" + (pug.escape(null == (pug_interp = text) ? "" : pug_interp)) + (null == (pug_interp = html) ? "" : pug_interp) + "\u003Cdiv class=\"t-end m-t\"\u003E\u003Cspan" + (pug.attr("class", pug.classes(["btn",state], [false,true]), false, false)+" d-value=\"ok\"") + "\u003E" + (pug.escape(null == (pug_interp = ok) ? "" : pug_interp)) + "\u003C\u002Fspan\u003E\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";}.call(this,"html" in locals_for_with?locals_for_with.html:typeof html!=="undefined"?html:undefined,"ok" in locals_for_with?locals_for_with.ok:typeof ok!=="undefined"?ok:undefined,"state" in locals_for_with?locals_for_with.state:typeof state!=="undefined"?state:undefined,"text" in locals_for_with?locals_for_with.text:typeof text!=="undefined"?text:undefined));;return pug_html;},confirm:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (cancel, html, ok, state, text) {pug_html = pug_html + "\u003Cdiv" + (pug.attr("class", pug.classes(["modal",state], [false,true]), false, false)) + "\u003E\u003Cdiv" + (pug.attr("class", pug.classes(["modal-body","c-xs","card","p","mw-y","r",state], [false,false,false,false,false,false,true]), false, false)) + "\u003E" + (pug.escape(null == (pug_interp = text) ? "" : pug_interp)) + (null == (pug_interp = html) ? "" : pug_interp) + "\u003Cdiv class=\"t-end m-t\"\u003E\u003Cspan class=\"btn flat\" d-value=\"cancel\"\u003E" + (pug.escape(null == (pug_interp = cancel) ? "" : pug_interp)) + "\u003C\u002Fspan\u003E\u003Cspan" + (pug.attr("class", pug.classes(["btn",state], [false,true]), false, false)+" d-value=\"ok\"") + "\u003E" + (pug.escape(null == (pug_interp = ok) ? "" : pug_interp)) + "\u003C\u002Fspan\u003E\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";}.call(this,"cancel" in locals_for_with?locals_for_with.cancel:typeof cancel!=="undefined"?cancel:undefined,"html" in locals_for_with?locals_for_with.html:typeof html!=="undefined"?html:undefined,"ok" in locals_for_with?locals_for_with.ok:typeof ok!=="undefined"?ok:undefined,"state" in locals_for_with?locals_for_with.state:typeof state!=="undefined"?state:undefined,"text" in locals_for_with?locals_for_with.text:typeof text!=="undefined"?text:undefined));;return pug_html;},autocompleteContent:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (element, showInput) {if (showInput) {
pug_html = pug_html + "\u003Cform class=\"shrink0 g\" v-submit=\"done input\"\u003E\u003Cinput" + (" class=\"f-input\""+" name=\"q\""+pug.attr("value", element.value, true, false)+" autocomplete=\"off\"") + "\u002F\u003E\u003Cinput" + (" class=\"btn primary\""+" type=\"submit\""+pug.attr("value", i18n.ok, true, false)) + "\u002F\u003E\u003C\u002Fform\u003E";
}
pug_html = pug_html + "\u003Cul class=\"menu results grow1 scroll-y\"\u003E\u003C\u002Ful\u003E";}.call(this,"element" in locals_for_with?locals_for_with.element:typeof element!=="undefined"?element:undefined,"showInput" in locals_for_with?locals_for_with.showInput:typeof showInput!=="undefined"?showInput:undefined));;return pug_html;},autocompleteResults:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (results) {if (results && results.length) {
var i= 0, len= results.length, result;
while (i < len) {
result= results[i++];
pug_html = pug_html + "\u003Cli" + (" class=\"m-item hover\""+pug.attr("d-value", result.id, true, false)) + "\u003E" + (null == (pug_interp = result.titleHTML) ? "" : pug_interp) + "\u003C\u002Fli\u003E";
}
}
else {
pug_html = pug_html + "\u003Cli class=\"m-item t-center disabled\"\u003E" + (null == (pug_interp = i18n.noResults) ? "" : pug_interp) + "\u003C\u002Fli\u003E";
}}.call(this,"results" in locals_for_with?locals_for_with.results:typeof results!=="undefined"?results:undefined));;return pug_html;},popupAutocomplete:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;pug_html = pug_html + "\u003Cdiv class=\"card flat f-col\"\u003E\u003C\u002Fdiv\u003E";;return pug_html;},inputDateDays:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (Date, attrs) {var i, days, startDay, cDate, lastDay, today;
pug_html = pug_html + "\u003Cdiv class=\"input-date-view grow1 grid xs7 grid-c pt\"\u003E";
i= 0, days= i18n.days;
while(i<7)
{
pug_html = pug_html + "\u003Cb\u003E" + (pug.escape(null == (pug_interp = days[i++]) ? "" : pug_interp)) + "\u003C\u002Fb\u003E";
}
cDate= new Date(attrs.currentDate);
today= cDate.getDate()
cDate.setDate(1);
startDay= cDate.getDay()+1;
cDate.setDate(35);
cDate.setDate(0);
lastDay= cDate.getDate();
pug_html = pug_html + "\u003Cdiv" + (" class=\"btn flat\""+pug.attr("style", pug.style('grid-column-start:'+startDay), true, false)+" d-click=\"select 1\"") + "\u003E1\u003C\u002Fdiv\u003E";
i= 2;
while (i <= lastDay) {
pug_html = pug_html + "\u003Cdiv" + (" class=\"btn flat\""+pug.attr("d-click", "select "+i, true, false)) + "\u003E" + (pug.escape(null == (pug_interp = i++) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E";
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";}.call(this,"Date" in locals_for_with?locals_for_with.Date:typeof Date!=="undefined"?Date:undefined,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDateGYears:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (attrs) {pug_html = pug_html + "\u003Cdiv class=\"input-date-view grow1 grid grid-c xs2 pt\"\u003E";
var i=0, startYear= attrs.currentDate.getFullYear() - 53; // - 5 - 12*4
while (i < 8) {
++i
pug_html = pug_html + "\u003Cdiv" + (" class=\"btn ouline\""+pug.attr("d-click", 'select '+(startYear+5), true, false)) + "\u003E" + (pug.escape(null == (pug_interp = startYear) ? "" : pug_interp)) + " - " + (pug.escape(null == (pug_interp = startYear+=11) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E";
++startYear;
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";}.call(this,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDateHeader:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (arrowIco, attrs) {pug_html = pug_html + "\u003Cdiv class=\"header shrink0 f-y pt\"\u003E\u003Cdiv class=\"grow1 truncate t-center\" d-click=\"go up\"\u003E";
var currentDate= attrs.currentDate;
var year= currentDate.getFullYear();
switch (attrs.currentView.name){
case 'g-years':
pug_html = pug_html + ((null == (pug_interp = year-53) ? "" : pug_interp) + " - " + (null == (pug_interp = year+42) ? "" : pug_interp));
  break;
case 'years':
pug_html = pug_html + ((null == (pug_interp = year-5) ? "" : pug_interp) + " - " + (null == (pug_interp = year+6) ? "" : pug_interp));
  break;
default:
pug_html = pug_html + (pug.escape(null == (pug_interp = attrs.currentView.pattern.format(currentDate)) ? "" : pug_interp));
  break;
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E\u003Cdiv class=\"g\"\u003E";
if (arrowIco) {
pug_html = pug_html + "\u003Cspan class=\"btn\" d-click=\"go up\"\u003E" + (null == (pug_interp = arrowIco.up) ? "" : pug_interp) + "\u003C\u002Fspan\u003E\u003Cspan class=\"btn\" d-click=\"go prev\"\u003E" + (null == (pug_interp = arrowIco.left) ? "" : pug_interp) + "\u003C\u002Fspan\u003E\u003Cspan class=\"btn\" d-click=\"go next\"\u003E" + (null == (pug_interp = arrowIco.right) ? "" : pug_interp) + "\u003C\u002Fspan\u003E";
}
else {
pug_html = pug_html + "\u003Cspan class=\"btn\" d-click=\"go up\"\u003E🡅\u003C\u002Fspan\u003E\u003Cspan class=\"btn\" d-click=\"go prev\"\u003E🡄\u003C\u002Fspan\u003E\u003Cspan class=\"btn\" d-click=\"go next\"\u003E🡆\u003C\u002Fspan\u003E";
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";}.call(this,"arrowIco" in locals_for_with?locals_for_with.arrowIco:typeof arrowIco!=="undefined"?arrowIco:undefined,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDateMonths:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (attrs) {pug_html = pug_html + "\u003Cdiv class=\"input-date-view grow1 grid grid-c xs4 pt\"\u003E";
var i=0, months= i18n.months;
var currentMonth= attrs.currentDate.getMonth()
while (i < 12) {
pug_html = pug_html + "\u003Cdiv" + (" class=\"btn flat\""+pug.attr("d-click", 'select '+i, true, false)) + "\u003E" + (pug.escape(null == (pug_interp = months[i++]) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E";
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";}.call(this,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDateTime:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (arrowIco, attrs) {var currentDate= attrs.currentDate, patterns= attrs.pattern.patterns;
var showHours, showMinutes, showSeconds, showMilliseconds, showAmPm, i, len, hasPrev= false;
len= patterns.length;
for(i=0; i < len; i++)
	switch(patterns[i]){
		case 'h':
		case 'hh':
			showHours= showAmPm= true; break;
		case 'H':
		case 'HH':
			showHours= true; break;
		case 'i':
		case 'ii':
			showMinutes= true; break;
		case 's':
		case 'ss':
			showSeconds= true; break;
		case 'S':
		case 'SS':
		case 'SSS':
			showMilliseconds= true; break;
	}

var hours= currentDate.getHours(), tt, minHour= 0, maxHour= 23;
if(showAmPm){
	minHour= 1
	maxHour= 12
	if(hours < 12){
		tt= 'AM'
		if(hours===0) hours= 12
	} else{
		tt= 'PM'
		if(hours>12) hours-= 12
	}
}
pug_html = pug_html + "\u003Cform class=\"input-date-view grow1 f-col\" v-submit=\"selectValue\"\u003E\u003Cdiv class=\"grow1 f-c pt\"\u003E";
if (showHours) {
hasPrev= true;
pug_html = pug_html + "\u003Cdiv class=\"gv f-cntrl\"\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc 1\"\u003E" + (null == (pug_interp = arrowIco.up) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003Cinput" + (" class=\"f-input w40px t-center\""+" type=\"number\" name=\"h\""+pug.attr("value", hours, true, false)+pug.attr("min", minHour, true, false)+pug.attr("max", maxHour, true, false)+pug.attr("d-loop", true, true, false)+pug.attr("d-select", true, true, false)+" tabindex=\"1\"") + "\u002F\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc -1\"\u003E" + (null == (pug_interp = arrowIco.down) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
if (showMinutes) {
if (hasPrev) {
pug_html = pug_html + " : ";
}
else {
hasPrev= true;
}
pug_html = pug_html + "\u003Cdiv class=\"gv f-cntrl\"\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc 1\"\u003E" + (null == (pug_interp = arrowIco.up) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003Cinput" + (" class=\"f-input w40px t-center\""+" type=\"number\" name=\"i\""+pug.attr("value", currentDate.getMinutes(), true, false)+" max=\"59\" min=\"0\""+pug.attr("d-loop", true, true, false)+pug.attr("d-select", true, true, false)+" tabindex=\"1\"") + "\u002F\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc -1\"\u003E" + (null == (pug_interp = arrowIco.down) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
if (showSeconds) {
if (hasPrev) {
pug_html = pug_html + " : ";
}
else {
hasPrev= true;
}
pug_html = pug_html + "\u003Cdiv class=\"gv f-cntrl\"\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc 1\"\u003E" + (null == (pug_interp = arrowIco.up) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003Cinput" + (" class=\"f-input w40px t-center\""+" type=\"number\" name=\"s\""+pug.attr("value", currentDate.getSeconds(), true, false)+" max=\"59\" min=\"0\""+pug.attr("d-loop", true, true, false)+pug.attr("d-select", true, true, false)+" tabindex=\"1\"") + "\u002F\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc -1\"\u003E" + (null == (pug_interp = arrowIco.down) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
if (showMilliseconds) {
if (hasPrev) {
pug_html = pug_html + " : ";
}
else {
hasPrev= true;
}
pug_html = pug_html + "\u003Cdiv class=\"gv f-cntrl\"\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc 1\"\u003E" + (null == (pug_interp = arrowIco.up) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003Cinput" + (" class=\"f-input w40px t-center\""+" type=\"number\" name=\"ms\""+pug.attr("value", currentDate.getMilliseconds(), true, false)+" max=\"99\" min=\"0\""+pug.attr("d-loop", true, true, false)+" placeholder=\"ss\""+pug.attr("d-select", true, true, false)+" tabindex=\"1\"") + "\u002F\u003E\u003Cdiv class=\"btn flat\" d-click=\"inc -1\"\u003E" + (null == (pug_interp = arrowIco.down) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
if (showAmPm) {
pug_html = pug_html + "\u003Cdiv class=\"f-cntrl\"\u003E\u003Cinput" + (" type=\"hidden\" name=\"tt\""+pug.attr("value", tt, true, false)) + "\u002F\u003E\u003Cdiv class=\"btn flat\" d-click=\"toggleTT\"\u003E" + (null == (pug_interp = tt) ? "" : pug_interp) + "\u003C\u002Fdiv\u003E\u003C\u002Fdiv\u003E";
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E\u003Cdiv class=\"t-end p5\"\u003E\u003Cinput" + (" class=\"btn primary\""+" type=\"submit\""+pug.attr("value", i18n.ok, true, false)) + "\u002F\u003E\u003C\u002Fdiv\u003E\u003C\u002Fform\u003E";}.call(this,"arrowIco" in locals_for_with?locals_for_with.arrowIco:typeof arrowIco!=="undefined"?arrowIco:undefined,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDateYears:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (attrs) {pug_html = pug_html + "\u003Cdiv class=\"input-date-view grow1 grid grid-c xs4 pt\"\u003E";
var i=0, startYear= attrs.currentDate.getFullYear() - 5;
while (i < 12) {
++i
pug_html = pug_html + "\u003Cdiv" + (" class=\"btn flat\""+pug.attr("d-click", 'select '+startYear, true, false)) + "\u003E" + (pug.escape(null == (pug_interp = startYear++) ? "" : pug_interp)) + "\u003C\u002Fdiv\u003E";
}
pug_html = pug_html + "\u003C\u002Fdiv\u003E";}.call(this,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined));;return pug_html;},inputDate:function(locals) {var pug_html = "", pug_mixins = {}, pug_interp;;var locals_for_with = (locals || {});(function (attrs, input) {pug_html = pug_html + "\u003Cinput" + (pug.attrs(pug.merge([{"class": "hidden","type": "hidden"},input]), false)) + "\u002F\u003E";
var CoreHTML= Core.html;
if (!(attrs.noHeader)) {
pug_html = pug_html + (null == (pug_interp = CoreHTML.inputDateHeader(locals)) ? "" : pug_interp);
}
switch (attrs.currentView.name){
case 'time':
pug_html = pug_html + (null == (pug_interp = CoreHTML.inputDateTime(locals)) ? "" : pug_interp);
  break;
case 'days':
pug_html = pug_html + (null == (pug_interp = CoreHTML.inputDateDays(locals)) ? "" : pug_interp);
  break;
case 'months':
pug_html = pug_html + (null == (pug_interp = CoreHTML.inputDateMonths(locals)) ? "" : pug_interp);
  break;
default:
pug_html = pug_html + (null == (pug_interp = CoreHTML.inputDateYears(locals)) ? "" : pug_interp);
  break;
}}.call(this,"attrs" in locals_for_with?locals_for_with.attrs:typeof attrs!=="undefined"?attrs:undefined,"input" in locals_for_with?locals_for_with.input:typeof input!=="undefined"?input:undefined));;return pug_html;},_:(function(){var e;return e=document.createElement("div"),function(r,t,i){var n,s,o,p;if(!(s=this[r]))throw"Unknown component: "+r;for(o=Array.isArray(t)?t.map(s).join(""):s(t),i&&(o=o.repeat(i)),e.innerHTML=o,p=e.childNodes,n=document.createDocumentFragment();p.length;)n.appendChild(p[0]);return n}})()};
	if(typeof Core.html=='object' && Core.html) Object.assign(Core.html, data);
	else Core.html=data;
})();