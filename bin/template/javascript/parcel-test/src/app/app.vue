<template>
	<div id="vue">
		<h1>Hello from {{ framework }} packaged with {{ packager }}!</h1>
	</div>
</template>

<script>
	export default {
		data() {
			return {
				framework: 'Vue',
				packager: 'Parcel',
			};
		}
	};
</script>

<style lang="scss" scoped>
	h1 {
		color: #05ede1;
	}
</style>
