// Some useful things to do in Jira console

// For Kanban / Scrum Board -> Component View
// show them by descending order of number of times used
// hiding less than 10 references
setInterval(
	function orderComponents() {
		const tbl = document.getElementById('components-table');
	  if (!tbl) { return; }
		const hdr = tbl.querySelectorAll('tbody.items');
	  if (!hdr || hdr.length < 1) { return }
		hdr[0].style.display = 'flex';
		hdr[0].style['flex-direction'] = 'column';
		const rows = document.querySelectorAll('tr.item-state-ready');
	  if (!rows || rows.length < 2) { return; }
		rows.forEach((tr, idx) => {
			const issues = tr.querySelectorAll('td');
		  if (!issues || issues.length < 3) { return; }
			const value = parseInt(issues[2].innerText);
		  if (isNaN(value)) { return; }
			tr.style.order = -value;
			if (value < 10) {
				tr.style.display = 'none';
			}
		});
	}
,1000);

