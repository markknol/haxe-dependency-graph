<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>dependency-graph</title>
	<meta name="description" content="" />
	<style>
	* { box-sizing:content-box; }
	body { font:14px arial,sans-serif; width:100%; height:100%; padding:10px; margin:0; overflow:hidden; }
	select { width: 70%; padding:5px; }
	a.dep { transform:translateX(-50%) translateY(-50%); padding: 5px 10px; position:absolute; z-index:2; border:1px solid rgba(0,0,0,.8); background:#fff;border-radius:4px; box-shadow:0 0 15px rgba(0,0,0,.2) }
	a.dep.selected { padding:10px; border:2px solid rgba(0,0,0,.8); }
	a.dep:hover { z-index: 4;rgba(255,255,255,.8); }
	#container { position:relative; width:95%; height:85%; margin-top:5px; }
	#canvas, #links { position:absolute; left:0; right:0; top:0; bottom:0; }
	
	.dragover { opacity:0.8; }
	#canvas { background:#f0f0f0}
	</style>
</head>
<body>
	Select class: <select id="dropdown"></select>
	<div id="container">
		<canvas id="canvas"></canvas>
		<div id="links"></div>
	</div>
	<script src="dependency-graph.js?v=<?=uniqid(); ?>"></script>
</body>
</html>