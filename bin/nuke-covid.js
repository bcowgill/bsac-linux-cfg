// hide the annoying covid sections on Facebook
javascript:
window.__nuke_me='.j83agx80.l9j0dhe7.k4urcfbm,.discj3wi.hv4rvrfc.ihqw7lf3.dati1w0a,.cxgpxx05.scb9dxdr.dflh9lhu';
window.__nuke_re=/(See the Latest Coronavirus Info|COVID-19 (vaccines go|Information Center)|Checked by independent fact|Get (COVID-19|Vaccine) Info|Explore Climate Science Info)/;
clearInterval(window.__nuke_covid);
window.__nuke_covid=setInterval(function(){var sections=[];document.querySelectorAll(window.__nuke_me).forEach((node)=>{if(node.innerText){sections.push(node)}});
window.__found=sections;
if (sections.length&&sections.length!==window.__last){
console.log('found',sections.length);var idx=Math.round(Math.random()*sections.length);
for(;idx<sections.length;++idx){if(sections[idx].innerText){console.log(sections[idx].innerText);idx=sections.length}}
}
window.__last=sections.length;
sections.forEach(function(node){if(window.__nuke_re.test(node.innerText)){console.log('hiding.covid.section',node.innerText);node.classList=['nuked-propaganda'];node.style = 'display: none'}})},1000)
xxx=document.querySelectorAll('.nukde-propaganda');
