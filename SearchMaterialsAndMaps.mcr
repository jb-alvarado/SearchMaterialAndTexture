/*
----------------------------------------------------------------------------------------------------------------------
::
::    Description: This MaxScript is for collecting materials, maps and texture, searching by name, 
::	   	   modify the texture path and copy the selection in the material editor.
::
----------------------------------------------------------------------------------------------------------------------
:: LICENSE ----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
::    Copyright (C) 2013 Jonathan Baecker (jb_alvarado)
::
::    This program is free software: you can redistribute it and/or modify
::    it under the terms of the GNU General Public License as published by
::    the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    This program is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU General Public License for more details.
::
::    You should have received a copy of the GNU General Public License
::    along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
:: History --------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
:: This is version 1.3. Last bigger modification was on 2014-02-16
:: 2013-05-27: build the script
:: 2013-06-01: rewrite and optimize the code 
:: 2013-06-02: Add support for multiple texture selections 
:: 2013-06-04: Add list filter options, and select object by material 
:: 2013-06-05: Add missing texture filter and small changes 
:: 2013-06-06: Optimize the search command and add a sort function for the texture list 
:: 2013-06-07: Add a sort function for the material list 
:: 2013-06-09: Add show texture slot checkbox and show material and texture from selected objects 
:: 2014-02-04: change listview to dotnet, add right click menu and remove some buttons 
:: 2014-02-05: fix fillup map array and add vray2side material 
:: 2014-02-06: add more map types 
:: 2014-02-07: fix right click menu, remove unused subarray and little fixes 
:: 2014-02-07: remove processbar and unused variables and functions 
:: 2014-02-09: makeup code, fix usability and bugs, better function for unnamed maps 
:: 2014-02-10: code optimisation, add tooltip text in the listview what shows the type 
:: 2014-02-16: optimize code - remove 1 subarray item, add drag&drop material to object (experimental), fix sort texture by name and make the list unique,
			- add better default material check - theoretical also all non standard materials and shader will work now 
:: 2014-02-17: fix list sorting, smoother listview size (?), add material to selection
:: 2014-02-18: bugfixes
:: 2014-02-19: add double click for texture preview 
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Maps
--
--	Author:   Jonathan Baecker (jb_alvardo) www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------
*/
macroScript SearchMaterialsAndMaps
 category:"jb_scripts"
 ButtonText:"SearchMaterialsAndMaps"
 Tooltip:"Search Materials And Maps"
( 
local SearchMaterialsAndMaps
(
	global colMats = #()
	global colMatsSub = #()
	global mapFiles= #()
	
-------------------------------------------------------------------
--Search maps by name function
-------------------------------------------------------------------
fn GetMaps mapName = (
	case classof mapName of (
		
		bitmaptexture: (
			join mapFiles #( mapName )
			)

		cellular: (
			join mapFiles #( mapName )
			
			if mapName.cellmap != undefined do (
				if classof mapName.cellmap != Bitmaptexture then (
					GetMaps mapName.cellmap
					) else (
						join mapFiles #( mapName.cellmap )
						)
				)
			if mapName.divmap1 != undefined do (
				if classof mapName.divmap1 != Bitmaptexture then (
					GetMaps mapName.divmap1
					) else (
						join mapFiles #( mapName.divmap1 )
						)
				)
			if mapName.divmap2 != undefined do (
				if classof mapName.divmap2 != Bitmaptexture then (
					GetMaps mapName.divmap2
					) else (
						join mapFiles #( mapName.divmap2 )
						)
				)
			)
		
		Checker: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
				
		ColorCorrection: (
			join mapFiles #( mapName )
			
			if mapName.map != undefined do (
				if classof mapName.map != Bitmaptexture then (
					GetMaps mapName.map
					) else (
						join mapFiles #( mapName.map )
						)
				)	
			)
			
		compositeTextureMap: (
			join mapFiles #( mapName )
			
			for b = 1 to mapName.maplist.count do (
				if classof mapName.maplist[b] != Bitmaptexture then (
					GetMaps mapName.maplist[b]
					) else (
						join mapFiles #( mapName.maplist[b] )
						)
				)
			for c = 1 to mapName.mask.count do (
				if classof mapName.mask[c] != Bitmaptexture then (
					GetMaps mapName.mask[c]
					) else (
						join mapFiles #( mapName.mask[c] )
						)
				)
			)
		
		dent: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)	
	
		Falloff: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
				
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		gradient: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)
			if mapName.map3 != undefined do (
				if classof mapName.map3 != Bitmaptexture then (
					GetMaps mapName.map3
					) else (
						join mapFiles #( mapName.map3 )
						)
				)
			)

		mask: (
			join mapFiles #( mapName )
			
			if mapName.map != undefined do (
				if classof mapName.map != Bitmaptexture then (
					GetMaps mapName.map
					) else (
						join mapFiles #( mapName.map )
						)
				)
			if mapName.mask != undefined do (
				if classof mapName.mask != Bitmaptexture then (
					GetMaps mapName.mask
					) else (
						join mapFiles #( mapName.mask )
						)
				)	
			)

		material_to_shader: (
			join mapFiles #( mapName )
			
			if mapName.material != undefined do ( 
				join mapFiles #( mapName.material )
				for a = 1 to ( getNumSubTexmaps mapName.material ) do (
					if ( ( getSubTexmap mapName.material a ) != undefined ) do (
						mapName2 = ( getSubTexmap mapName.material a )
						GetMaps mapName2
						)
					)
				)
			)
			
		mix: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		noise: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Normal_Bump: (
			join mapFiles #( mapName )
			
			if mapName.normal_map != undefined do (
				if classof mapName.normal_map != Bitmaptexture then (
					GetMaps mapName.normal_map
					) else (
						join mapFiles #( mapName.normal_map )
						)
				)
			if mapName.bump_map != undefined do (
				if classof mapName.bump_map != Bitmaptexture then (
					GetMaps mapName.bump_map
					) else (
						join mapFiles #( mapName.bump_map )
						)
				)	
			)
			
		output: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			)
			
		perlinMarble: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)	
		
		rgbMult: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Smoke: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Speckle: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Splat: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)
			
		Stucco: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)	
			
		Stucco: (
			join mapFiles #( mapName )
			
			if mapName.map1 != undefined do (
				if classof mapName.map1 != Bitmaptexture then (
					GetMaps mapName.map1
					) else (
						join mapFiles #( mapName.map1 )
						)
				)
			if mapName.map2 != undefined do (
				if classof mapName.map2 != Bitmaptexture then (
					GetMaps mapName.map2
					) else (
						join mapFiles #( mapName.map2 )
						)
				)	
			)	

		default: (
			if mapName != undefined do (
				join mapFiles #( mapName )
				propertyArray = #()
				propNames = getPropNames mapName
				
				for p = 1 to propNames.count do (
					try (
						property = getProperty mapName propNames[p] 
						if superclassof property == textureMap do (
							join propertyArray #( property )
							)
						) catch ()
					)
				for prop in propertyArray do GetMaps prop 
				)
			)
		)
	)

-------------------------------------------------------------------
--send maps to GetMaps function
-------------------------------------------------------------------	
fn GetBitmaps mtl = (
	mapArray = #()
	if superclassof mtl == textureMap then (
			GetMaps mtl
			join mapArray #( mapFiles )
			mapFiles = #()
		) else (
			for a = 1 to (getNumSubTexmaps mtl) do (
				if ( ( getSubTexmap mtl a ) != undefined ) do (
					mapName = ( getSubTexmap mtl a )
					GetMaps mapName
					join mapArray #( mapFiles )
					mapFiles = #()
					)
				)
			)
			
	for b = 1 to mapArray.count do (
		for c = 1 to mapArray[b].count do (
			join colMats #( colMatsSub= #( mapArray[b][c] ) )
			if classof mapArray[b][c] == bitmaptexture then (
				join colMatsSub #( "tex" )
				) else (
					join colMatsSub #( "map" )
					)
			)
		)
	)

-------------------------------------------------------------------
--Search material by name function
-------------------------------------------------------------------
fn matlists mtl type = (
	local checkType = #( Blend, CompositeMaterial, doubleSided, MultiMaterial, Shellac, Shell_Material, TopBottom, VRay2SidedMtl )
	
	case classof mtl of (

		Blend: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			local blendMat = #()

			if (mtl.map1 != undefined ) do (
				if ( findItem checkType ( classof mtl.map1 ) > 0 ) then (
					matlists mtl.map1 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.map1 ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.map1
						)
				)
			if ( mtl.map2 != undefined ) do (
				if ( findItem checkType ( classof mtl.map2 ) > 0 ) then (
					matlists mtl.map2 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.map2 ) )
						join colMatsSub #( "sub" )
							
						GetBitmaps mtl.map2
						)
				)
			if ( mtl.mask != undefined ) do (
				GetBitmaps mtl.mask
				)
		)

		Shellac: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			if ( mtl.shellacMtl1 != undefined ) do (
				if ( findItem checkType ( classof mtl.shellacMtl1 ) > 0 ) then (
					matlists mtl.shellacMtl1 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.shellacMtl1 ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.shellacMtl1
						)
				)
			if ( mtl.shellacMtl2 != undefined ) do (
				if ( findItem checkType ( classof mtl.shellacMtl2 ) > 0 ) then (
					matlists mtl.shellacMtl2 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.shellacMtl2 ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.shellacMtl2
						)
				)
		)

		TopBottom: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			if ( mtl.topMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.topMaterial ) > 0 ) then (
					matlists mtl.topMaterial "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.topMaterial ) )
						join colMatsSub #( "sub" )	

						GetBitmaps mtl.topMaterial
						)
				)
			if ( mtl.bottomMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.bottomMaterial ) > 0 ) then (
					matlists mtl.bottomMaterial "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.bottomMaterial ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.bottomMaterial
						)
				)
		)

		doubleSided: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			if ( mtl.material1 != undefined ) do (
				if ( findItem checkType ( classof mtl.material1 ) > 0 ) then (
					matlists mtl.material1 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.material1 ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.material1
						)
				)
			if ( mtl.material2 != undefined ) do (
				if ( findItem checkType ( classof mtl.material2 ) > 0 ) then (
					matlists mtl.material2 "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.material2 ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.material2	
						)
				)
		)

		VRay2SidedMtl: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			if ( mtl.frontMtl != undefined ) do (
				if ( findItem checkType ( classof mtl.frontMtl ) > 0 ) then (
					matlists mtl.frontMtl "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.frontMtl ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.frontMtl
						)
				)
			if ( mtl.backMtl != undefined ) do (
				if ( findItem checkType ( classof mtl.backMtl ) > 0 ) then (
					matlists mtl.backMtl "sub"
					) else (
						join colMats  #( colMatsSub = #( mtl.backMtl ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.backMtl	
						)
				)
			if ( mtl.texmap_translucency != undefined ) do (
				GetBitmaps mtl
				)	
		)

		Shell_Material: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			if ( mtl.originalMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.originalMaterial ) > 0 ) then (
					matlists mtl.originalMaterial "sub"
					) else (
						join colMats  #( colMatsSub = #(mtl.originalMaterial ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.originalMaterial
						)
				)
			if ( mtl.bakedMaterial != undefined ) do (
				if ( findItem checkType ( classof mtl.bakedMaterial ) > 0 ) then (
					matlists mtl.bakedMaterial "sub"
					) else (
						join colMats  #( colMatsSub = #(mtl.bakedMaterial ) )
						join colMatsSub #( "sub" )

						GetBitmaps mtl.bakedMaterial
						)
				)
		)

		MultiMaterial: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			local m
			for m = 1 to mtl.numsubs do (
				if ( mtl[m] != undefined ) do (
					if ( findItem checkType ( classof mtl[m] ) > 0 ) then (
						matlists mtl[m]  "sub"
						) else (
							join colMats  #( colMatsSub = #(mtl[m] ) )
							join colMatsSub #( "sub" )

							GetBitmaps mtl[m]
							)
					)
			)
		)

		CompositeMaterial: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)

			local c
			for c = 1 to mtl.materialList.count do (
				if ( mtl.materialList[c] != undefined ) do (
					if ( findItem checkType ( classof mtl.materialList[c] ) > 0 ) then (
						matlists mtl.materialList[c] "sub"
						) else (
							join colMats  #( colMatsSub = #( mtl.materialList[c] ) )
							join colMatsSub #( "sub" )

							GetBitmaps mtl.materialList[c]
							)
					)
			)
		)
		--------------------------------------------------
		--all other materials
		--------------------------------------------------
		default: (
			if type == "sub" then (
				join colMats  #( colMatsSub = #( mtl ) )
				join colMatsSub #( "sub" )
				) else (
					join colMats  #( colMatsSub = #( mtl ) )
					join colMatsSub #( "mat" )
					)
					
			if ( superclassof mtl == material ) do (
				if ( getNumSubMtls mtl > 0 ) do (
					for d = 1 to getNumSubMtls mtl do (
						if ( getSubMtl mtl d ) != undefined do (
							matlists ( getSubMtl mtl d ) "sub"
							)
						)
					)
				)
			GetBitmaps mtl		
			)
			
		) --case end
		
	) --fn matlists end

try ( destroyDialog SearchMaterialAndMaps ) catch ( )	

rollout SearchMaterialAndMaps "Search Materials And Maps" width:340 height:570 (
	
	local ProgramName = "Search Material and Maps"
	local sortOrder = dotNetClass "System.Windows.Forms.SortOrder"
	local listVis = #()
	local listBG = #()
	local selectionArray = #()
	local selectionNums = #()
	local edtBoxText = ""
	
	local theMat
	local theObject
  	local dragFlag = false
	
	local liCol = ( ( colorman.getColor #background )*255 ) as color
	
	--Returns the object at the mouse position in the viewport	
	fn hitTest = (
		local theRay = mapScreenToWorldRay mouse.pos
		local dist = undefined
		local theHit = undefined
		local hitObject = undefined
		for x in objects do (
			hitRay = intersectRay x theRay
			if hitRay != undefined then (
				tempDist = distance hitRay.pos theRay.pos
				if dist == undefined or tempDist < dist then (
					dist = tempDist
					theHit = hitRay
					hitObject = X
					)
				)
			)
		hitObject 
		)

	groupBox grpSeMyTex "Collection From All Materials And Maps:" pos:[10,8] width:320 height:502
		editText edtMat "" pos:[16,26] width:240 readOnly:true
		button btnChangeTex "Browse" pos:[260,26] width:60 height:18
		dotNetControl mlbxMatsAndTexs "system.windows.forms.listView" pos:[20,47] width:300 height:413
		checkBox chkMat "Materials" pos:[20,467] checked:true
		checkBox chkSub "Submats" pos:[20,487] checked:true
		checkBox chkMap "Maps" pos:[125,467] checked:true
		checkBox chkTex "Textures" pos:[125,487] checked:true
		checkBox chkmissing "Missing Texture" pos:[225,467] checked:false
		checkBox chkSelObj "From Selection" pos:[225,487] checked:false

	groupBox grpSeByName "Search Material And Maps By Name:" pos:[10,515] width:320 height:45
		editText edtBox text:"" pos:[16,533] width:244
		button btnSeMat "Search" pos:[270,533] width:50 height:20

	-----------------------------------------------
	--resize statment
	-----------------------------------------------
	on SearchMaterialAndMaps resized newSize do (
		grpSeMyTex.width=newSize[1]-20
		grpSeMyTex.height=newSize[2]-68
			edtMat.width=newSize[1]-105
			btnChangeTex.pos=[newSize[1]-80,26] 
			mlbxMatsAndTexs.width=newSize[1]-40
			mlbxMatsAndTexs.height=newSize[2]-157

			if listBG.count <= ( mlbxMatsAndTexs.height / 17 ) then (  
				try ( mlbxMatsAndTexs.columns.item[0].width = newSize[1]-46 ) catch ()
				) else (
					try ( mlbxMatsAndTexs.columns.item[0].width = newSize[1]-64 ) catch ()
					)
					
			chkMat.pos=[20,newSize[2]-103]
			chkSub.pos=[20,newSize[2]-83]
			chkMap.pos=[newSize[1]/2-45,newSize[2]-103]
			chkTex.pos=[newSize[1]/2-45,newSize[2]-83]
			chkmissing.pos=[newSize[1]-115,newSize[2]-103]
			chkSelObj.pos=[newSize[1]-115,newSize[2]-83]

		grpSeByName.width=newSize[1]-20
		grpSeByName.pos=[10, newSize[2]-55]
			edtBox.width=newSize[1]-100
			edtBox.pos=[20,newSize[2]-37]
			btnSeMat.pos=[newSize[1]-70,newSize[2]-37]
		)

-----------------------------------------------
--Progress, fill material and texture array
-----------------------------------------------
	fn doMaterialList materials = (
		--reset material and texture array
		mlbxMatsAndTexs.items.clear()
		mlbxMatsAndTexs.Sorting = SortOrder.None
		matArray = #()
		colMats = #()
		colMatsSub = #()
		listVis = #()
		listBG = #()
		listBGType = #()

		fn compMatNames name1 name2 = stricmp name1.name name2.name
 
		matArray = for mat in materials collect mat
		qSort matArray compMatNames
		
		clearlistener()
		startID = timeStamp()
		
		for i = 1 to matArray.count do (
			matlists matArray[i] "run"
			)

		--get names from materials and textures
		for m = 1 to colMats.count do (
			if ( chkMat.checked == true AND colMats[m][2] == "mat" ) then (
				li=dotNetObject "System.Windows.Forms.ListViewItem" colMats[m][1].name
				li.backColor=li.backColor.fromARGB (liCol.r + 20) (liCol.g + 10) (liCol.b + 10)
				li.ToolTipText = classof colMats[m][1] as string
				append listVis li

				join listBG  #( listBGType = #( colMats[m][1] ) )
				join listBGType #( colMats[m][2] )
				) else if ( chkSub.checked == true AND colMats[m][2] == "sub" ) then (
					li=dotNetObject "System.Windows.Forms.ListViewItem" ( "   " + colMats[m][1].name )
					li.backColor=li.backColor.fromARGB (liCol.r + 30) (liCol.g + 30) (liCol.b + 20)
					li.ToolTipText = classof colMats[m][1] as string
					append listVis li
					
					join listBG  #( listBGType = #( colMats[m][1] ) )
					join listBGType #( colMats[m][2] )
					) else if ( chkMap.checked == true AND colMats[m][2] == "map" ) then (
						li=dotNetObject "System.Windows.Forms.ListViewItem" ( "      " + colMats[m][1].name )
						li.backColor=li.backColor.fromARGB (liCol.r + 30) (liCol.g + 30) (liCol.b + 40)
						li.ToolTipText = classof colMats[m][1] as string
						append listVis li
						
						join listBG  #( listBGType = #( colMats[m][1] ) )
						join listBGType #( colMats[m][2] )
						) else if ( chkTex.checked == true AND colMats[m][2] == "tex" ) then (
							if (  colMats[m][1].filename == undefined OR colMats[m][1].filename == "" ) then (
								li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           ! Warning: empty bitmap texture !" )
							) else (
								li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           " + filenameFromPath colMats[m][1].filename )
								)
							
							li.backColor=li.backColor.fromARGB (liCol.r + 40) (liCol.g + 50) (liCol.b + 40)
							li.ToolTipText = classof colMats[m][1] as string
							append listVis li
									
							join listBG  #( listBGType = #( colMats[m][1] ) )
							join listBGType #( colMats[m][2] )
							) else if ( chkmissing.checked == true AND colMats[m][2] == "tex" ) then (
								if (  colMats[m][1].filename == undefined OR colMats[m][1].filename == "" ) then (
									if ( chkTex.checked == true ) then (
										li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           ! Warning: empty bitmap texture !" )
										li.backColor=li.backColor.fromARGB (liCol.r + 40) (liCol.g + 50) (liCol.b + 40)
										li.ToolTipText = classof colMats[m][1] as string
										append listVis li
										) else (
											li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           ! Warning: empty bitmap texture !" )
											li.backColor=li.backColor.fromARGB (liCol.r + 40) (liCol.g + 50) (liCol.b + 40)
											li.ToolTipText = classof colMats[m][1] as string
											append listVis li
											)
										join listBG  #( listBGType = #( colMats[m][1] ) )
										join listBGType #( colMats[m][2] )
									) else if not ( doesFileExist colMats[m][1].filename ) then (
										if ( chkmissing.checked == true ) then (
										li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           " + filenameFromPath colMats[m][1].filename )
										li.backColor=li.backColor.fromARGB (liCol.r + 40) (liCol.g + 50) (liCol.b + 40)
										li.ToolTipText = classof colMats[m][1] as string
										append listVis li
										) else (
											li=dotNetObject "System.Windows.Forms.ListViewItem" ( "           " + filenameFromPath colMats[m][1].filename )
											li.backColor=li.backColor.fromARGB (liCol.r + 40) (liCol.g + 50) (liCol.b + 40)
											li.ToolTipText = classof colMats[m][1] as string
											append listVis li
											)
										join listBG  #( listBGType = #( colMats[m][1] ) )
										join listBGType #( colMats[m][2] )
										)
								)
			)

			--fill the listBox mlbxMatsAndTexs box
			mlbxMatsAndTexs.items.addRange listVis
			
			--sort array when only textures selected
			if ( chkMat.checked == false AND chkSub.checked == false AND chkMap.checked == false AND chkTex.checked == false AND chkmissing.checked == true ) then (
				for i= 1 to listBG.count do (
						for j = listBG.count to i+1 by -1 do (
							if ( listBG[i][1].filename != undefined AND listBG[i][1].filename != "" AND listBG[j][1].filename != undefined AND listBG[j][1].filename != "" ) do (
								if listBG[i][1].filename == listBG[j][1].filename do (
									deleteItem listBG j
									mlbxMatsAndTexs.Items.RemoveAt[j-1]
									)
								)
							)
						)

				sortList = #()
				mlbxMatsAndTexs.Sorting = sortOrder.Ascending;
					
				for k = 1 to mlbxMatsAndTexs.items.count do (
					searchStr = substring mlbxMatsAndTexs.items.item[k-1].text 12 -1
					for l = 1 to listBG.count do (
						if listBG[l][1].filename != undefined AND listBG[l][1].filename != "" then (
							if searchStr == filenameFromPath listBG[l][1].filename do (
								appendIfUnique sortList listBG[l]
								)
							) else ( appendIfUnique sortList listBG[l] )
						)
					)
					listBG = sortList	
				) else if ( chkMat.checked == false AND chkSub.checked == false AND chkMap.checked == false AND chkmissing.checked == false AND chkTex.checked == true ) then (		
					for i= 1 to listBG.count do (
						for j = listBG.count to i+1 by -1 do (
							if ( listBG[i][1].filename != undefined AND listBG[i][1].filename != "" AND listBG[j][1].filename != undefined AND listBG[j][1].filename != "" ) do (
								if listBG[i][1].filename == listBG[j][1].filename do (
									deleteItem listBG j
									mlbxMatsAndTexs.Items.RemoveAt[j-1]
									)
								)
							)
						)

					sortList = #()
					mlbxMatsAndTexs.Sorting = sortOrder.Ascending;
						
					for k = 1 to mlbxMatsAndTexs.items.count do (
						searchStr = substring mlbxMatsAndTexs.items.item[k-1].text 12 -1
						for l = 1 to listBG.count do (
							if listBG[l][1].filename != undefined AND listBG[l][1].filename != "" then (
								if searchStr == filenameFromPath listBG[l][1].filename do (
									appendIfUnique sortList listBG[l]
									)
								) else ( appendIfUnique sortList listBG[l] )
							)
						)
						listBG = sortList					
					)
				
		if listBG.count <= ( mlbxMatsAndTexs.height / 17 ) then (
			mlbxMatsAndTexs.columns.item[0].width = SearchMaterialAndMaps.width - 46
			) else (
				mlbxMatsAndTexs.columns.item[0].width = SearchMaterialAndMaps.width - 64
				)
		mlbxMatsAndTexs.Update()
				
		stampID = timeStamp()			
		print ( (stampID - startID) / 1000.0 )			
		)
		
		
on SearchMaterialAndMaps open do (
	--Setup the forms view
	mlbxMatsAndTexs.HeaderStyle = none
	mlbxMatsAndTexs.columns.add "" 278
	mlbxMatsAndTexs.view = ( dotNetClass "system.windows.forms.view" ).details
	mlbxMatsAndTexs.FullRowSelect = true
	mlbxMatsAndTexs.GridLines = false
	mlbxMatsAndTexs.MultiSelect = true
	mlbxMatsAndTexs.HideSelection = false
	mlbxMatsAndTexs.ShowItemToolTips = true
	--mlbxMatsAndTexs.allowdrop = true
	mlbxMatsAndTexs.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB (liCol.r + 20) (liCol.g + 20) (liCol.b + 20)
	cf = ( ( colorman.getColor #text )*255+30 ) as color
	mlbxMatsAndTexs.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB cf.r cf.g cf.b
	doMaterialList sceneMaterials
	)

-------------------------------------
--selected list entry
-------------------------------------
on mlbxMatsAndTexs MouseClick arg do (
	selectionArray = #()
	selectionArraySub = #()
	selectionNums = #()
	
	for k = 0 to mlbxMatsAndTexs.selectedIndices.count-1 do (
		it = mlbxMatsAndTexs.selectedIndices.item[k] + 1
		join selectionArray  #( selectionArraySub = #( listBG[it][1] ) )
		join selectionArraySub #( listBG[it][2] )
		join selectionNums #( it - 1 )
		)

		if ( selectionArray.count == 1 AND selectionArray[1][2] == "tex" ) then (
			if ( selectionArray[1][1].filename == undefined OR selectionArray[1][1].filename == "" ) then (
				edtMat.text = "Warning: empty bitmap texture!"
				) else (
					edtMat.text = selectionArray[1][1].filename
					)
			) else if ( selectionArray.count == 1 AND selectionArray[1][2] != "tex" ) then (
				edtMat.text = selectionArray[1][1].name
				) else if ( selectionArray.count > 1 ) then (
					for t = 1 to selectionArray.count do (
						if ( selectionArray[t][2] == "tex" ) then (
							if ( selectionArray[t][1].filename == undefined OR selectionArray[t][1].filename == "" ) then (
								messagebox "Texture file is not set, please correct this first!" title:ProgramName
								deleteItem selectionArray t
								
								mlbxMatsAndTexs.Items.item[selectionNums[t]].Selected = false
								exit
								) else if ( selectionArray[1][2] == "tex" ) then (
									edtMat.text = getFilenamePath selectionArray[1][1].filename
									) else (
										messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName
										)
							) else if ( selectionArray[t][2] != "tex" ) then (
								messagebox "Multiple selections is only for BitmapTextures allowed!" title:ProgramName
								deleteItem selectionArray t
								edtMat.text = selectionArray[1][1].name

								mlbxMatsAndTexs.Items.item[selectionNums[t]].Selected = false
								exit
								)
						)
					)			
	)

-----------------------------------------------
--browse texture
-----------------------------------------------	
fn browseTexFile selectionArray = (
	if ( selectionArray.count == 0 ) do (
		MessageBox "Please select a texture map first!" title:ProgramName
		return false
		)
		
	if ( selectionArray.count == 1 AND superclassof selectionArray[1][1] == Material ) then (
		MessageBox "Please select a texture map..." title:ProgramName
		return false
		) else if ( selectionArray.count == 1 AND selectionArray[1][2] == "tex" ) then (
			try ( 
				filepath = getFilenamePath selectionArray[1][1].filename + filenameFromPath selectionArray[1][1].filename
				) catch (
					filepath = ( getDir #renderPresets + @"\" )
					)
			inputFile = getOpenFileName \
			caption:"Select Bitmap Image File" \
			filename:filepath \
			types:"All Files (*.*)|*.*|AVI File (*.avi)|*.avi|Mpeg File (*.mpg,*.mpeg)|*.mpg;*.mpeg|BMP Image File (*.bmp)|*.bmp|Kodak Cineon (*.cin)|*.cin\
				|Combustion* by Discreet (*.cws)|*.cws|OpenEXR Image File (*.exr)|*.exr|GIF Image File (*.gif)|*.gif|Radiance Image File (HDRI) (*.hdr*.pic)|*.hdr;*.pic\
				|ILF Image File (*.ifl)|*.ifl|JPEG Image File (*.jpg,*.jpe,*.jpeg)|*.jpg;*.jpe;*.jpeg|PNG Image File (*.png)|*.png|Adobe PSD Reader (*.psd)|*.psd\
				|MOV QuickTime File (*.mov)|*.mov|SGI Image File (*.rgb,*.rgba,*.sgi,*.int,*.inta,*.bw)|*.rgb;*.rgba;*.sgi;*.int;*.inta,*.bw|RLA Image File (*.rla)|*.rla\
				|RPF (*.rpf)|*.rpf|Targa Image File (*.tga)|*.tga|Tif Image File (*.tif,*.tif)|*.tif;*.tiff|YUV Image File (*.yuv)|*.yuv|DDS Image File (*.dds)|*.dds|" \
			historyCategory:"Textures"

			if ( inputFile != undefined ) do (
				selectionArray[1][1].filename = inputFile
				edtMat.text = inputFile
				)
			) else if ( selectionArray[1][2] == "tex" ) then (
				try (
					filepath = getFilenamePath selectionArray[1][1].filename
					folder = getSavePath caption:"Select Path:" initialDir:(filepath)
					) catch (
						MessageBox "Please change undefined texture file by file!" title:ProgramName
						)
					
				if folder != undefined do (
					inDir = getFilenamePath ( folder + "/" )
					for y = 1 to selectionArray.count do (
						try ( 
							selectionArray[y][1].filename = ( inDir + filenameFromPath selectionArray[y][1].filename )
							edtMat.text = inDir
							) catch (
								MessageBox "Please change undefined texture file by file!" title:ProgramName
								edtMat.text = "Warning: empty bitmap texture!"
								exit
								)
						
						)
					)
				) else (
					MessageBox "Please select a texture map..." title:ProgramName
					)

		if ( chkSelObj.checked == true ) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList ( makeUniqueArray SelObjMats )
			) else (
				doMaterialList sceneMaterials
				)
	)
	
-----------------------------------------------
--right click menu
-----------------------------------------------	
struct lv_context_menu (
	fn EditPath = (	
		browseTexFile selectionArray
		),
	fn null = (),
	fn CopyToMaterialEditor sender arg = (	
			local meditMatch = 0
			local i

			for i = 1 to meditMaterials.count do (
				if ( matchPattern ( meditMaterials [i].name ) pattern:selectionArray[1][1].name ) do (
					activeMeditSlot = i
					MessageBox ( "Material or Textures is already in Material Editor! SLOT: " + ( i as string ) ) title:ProgramName
					meditMatch = 1
					) 
				)
			if ( meditMatch == 0 ) do (
				setMeditMaterial sender.tag selectionArray[1][1]
				)
		),
	fn AddMaterialToSelection = (
		if selectionArray.count == 1 AND superclassof selectionArray[1][1] == Material do (
			for sel in selection do sel.material = selectionArray[1][1]
			)
		),	
	fn SelectObjectsByMaterial = (
		objArray = for obj in Geometry where obj.material != undefined AND obj.material.name == selectionArray[1][1].name collect obj
			
		-- Check if the obj is part of a group
		for obj in objArray where isGroupMember obj AND ( NOT isOpenGroupMember obj ) do (
			par = obj.parent
			while par != undefined do (
				if isGroupHead par then (
					setGroupOpen par true
					par = undefined
					) else (
						par = par.parent
						)
				)
			)
			select objArray
			
			for o in objArray where not( o.layer.on ) do o.layer.on = true
			for o in objArray where o.layer.isFrozen do o.layer.isFrozen = false
			for o in objArray where o.isHidden do o.isHidden = false
			for o in objArray where o.isFrozen do o.isFrozen = false
			select objArray
		),
	fn RefreshList = (
		if ( chkSelObj.checked == true ) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList ( makeUniqueArray SelObjMats )
			) else (
				doMaterialList sceneMaterials
				)
		),
	fn OpenInExplorer = (
		if selectionArray.count == 1 then (
			ShellLaunch "explorer.exe" ( "/e,/select," + ( getFilenamePath selectionArray[1][1].filename + filenameFromPath selectionArray[1][1].filename ) )
			) else (
				ShellLaunch "explorer.exe" ( getFilenamePath selectionArray[1][1].filename )
				)
		),
	names = #( "&Edit Path","-", "&Copy To Material Editor", "&Add Material To Selection", "&Select Objects By Material", "-", "&Refresh List", "&Open Path" ), --Asign To Object; Search Material from Selected Object
	eventHandlers = #( EditPath, null, CopyToMaterialEditor, AddMaterialToSelection, SelectObjectsByMaterial, null, RefreshList, OpenInExplorer ),
	events = #( "Click", "Click", "Click", "Click", "Click", "Click", "Click", "Click" ),
	
	fn GetMenu type= (
		cm = ( dotNetObject "System.Windows.Forms.ContextMenu" )
		for i = 1 to names.count do (
			mi = cm.MenuItems.Add names[i]
			
			if type != "tex" do (
				if names[i] == "&Edit Path" OR names[i] == "&Open Path" do (
					mi.enabled = off
					)
				)
				
			if type != "mat" AND names[i] == "&Select Objects By Material" do (
				mi.enabled = off
				)
				
			if type != "mat" AND type != "sub" do (
					if names[i] == "&Add Material To Selection" do (
					mi.enabled = off
					)
				)	
				
			if type == "null" AND names[i] != "&Refresh List" do (
				mi.enabled = off
				)				
				
			if names[i] == "&Copy To Material Editor" do (
				for m = 1 to meditmaterials.count do (
					if m < 10 then (
						item = mi.menuitems.add ( "Slot:   " + m as string )
						) else (
							item = mi.menuitems.add ( "Slot: " + m as string )
							)
					item.tag = m
					dotnet.addEventHandler item events[i] eventHandlers[i]
					)
				)

			dotNet.addEventHandler  mi events[i] eventHandlers[i]
			dotNet.setLifetimeControl mi #dotnet
			)	
		cm
		)
	)

-------------------------------------
--mouse events
-------------------------------------
on mlbxMatsAndTexs ItemDrag arg do (
	dragFlag = true
	theMat = listBG[arg.item.index+1][1]
  	)

on mlbxMatsAndTexs mouseUp sender args do (
	dragFlag = false
	
	mlbxMatsAndTexs.ContextMenu = ()
	hit=( mlbxMatsAndTexs.HitTest ( dotNetObject "System.Drawing.Point" args.x args.y ) )

	if hit.item != undefined AND selectionArray[1] != undefined then (
		if selectionArray[1][2] == "tex" then (
			cm = lv_context_menu()
			mlbxMatsAndTexs.ContextMenu = cm.getmenu( selectionArray[1][2] )
			) else if selectionArray.count == 1 AND selectionArray[1][2] != "tex" then (
				cm = lv_context_menu()
				mlbxMatsAndTexs.ContextMenu = cm.getmenu( selectionArray[1][2] )
				)
		) else (
			cm = lv_context_menu()
			mlbxMatsAndTexs.ContextMenu = cm.getmenu( "null" )
			)
	)
	
on mlbxMatsAndTexs lostFocus arg do (
	theObject = hitTest()
	if theObject != undefined AND superclassof theMat == Material AND dragFlag == true do (
		theObject.material = theMat
		)
	theObject = undefined
  	)
	
on mlbxMatsAndTexs MouseDoubleClick arg do (
	if selectionArray.count == 1 AND selectionArray[1][2] == "tex" do (
		bitm = openbitmap selectionArray[1][1].filename
		display bitm
		)
	)
-------------------------------------
--Browse Texture button
-------------------------------------
on btnChangeTex pressed do (
	browseTexFile selectionArray
	)

-------------------------------------
--checkboxen - filter functions
-------------------------------------
on chkMat changed theState do (
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkSub changed theState do (
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)	

on chkMap changed theState do (
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkTex changed theState do (
	chkmissing.checked = false
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)

on chkmissing changed theState do (
	chkTex.checked = false
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)
	
on chkSelObj changed theState do (
	if ( chkSelObj.checked == true ) then (
		SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
		doMaterialList ( makeUniqueArray SelObjMats )
		) else (
			doMaterialList sceneMaterials
			)
	)	
-------------------------------------
--search material by name
-------------------------------------
fn searchByName intext = (
	selectionArray = #()
	selectionArraySub = #()

	if ( edtBox.text != "" ) then (
		if ( chkSelObj.checked == true ) then (
			SelObjMats = for selObj in selection where selObj.mat != undefined collect selObj.mat
			doMaterialList ( makeUniqueArray SelObjMats )
			) else (
				doMaterialList sceneMaterials
				)

		--check if material or texture name exist
		local NameMatch = undefined
		local NameIndex = 1
		local NumCount = #()

		for f = 1 to listBG.count do (
			if ( listBG[f][1].name == edtBox.text ) then (
				NameMatch = listBG[f][1]
				NameIndex = f
				join NumCount #(f)
				) else if ( listBG[f][2] == "tex" AND ( try ( filenameFromPath listBG[f][1].filename ) catch ( listBG[f][1].name ) ) == edtBox.text ) then (
					NameMatch = listBG[f][1]
					NameIndex = f
					join NumCount #(f)
					)
			)

		--count textures, or materials with the same name
		if ( NumCount.count > 1 AND listBG[NameIndex][2] == "tex" ) then (
			MessageBox ( "Texture is \"" + NumCount.count as string + "\" times in use..." ) title:ProgramName
			for i = 1 to NumCount.count do (
				mlbxMatsAndTexs.Items.item[NumCount[i]-1].Selected = true
				mlbxMatsAndTexs.EnsureVisible[NumCount[i]-1]
				)
				
			for numSe in NumCount do (
				join selectionArray  #( selectionArraySub = #( listBG[numSe][1] ) )
				join selectionArraySub #( listBG[numSe][2] )
				)
			try ( edtMat.text = getFilenamePath selectionArray[1][1].filename ) catch ( edtMat.text = "Warning: empty bitmap texture!" )
			return false
			) else if ( NumCount.count > 1 AND listBG[NameIndex][2] == "mat" ) then (
				MessageBox ("Materialname is \"" + NumCount.count as string + "\" times in use!") title:ProgramName
				) else if ( NumCount.count > 1 AND listBG[NameIndex][2] == "map" ) then (
					MessageBox ("Mapname is \"" + NumCount.count as string + "\" times in use!") title:ProgramName
					)

		--jump to the searched material or texture
		if ( NameMatch != undefined ) then (
				for g = 1 to NumCount.count do (
					mlbxMatsAndTexs.Items.item[NumCount[g]-1].Selected = true
					mlbxMatsAndTexs.EnsureVisible[NumCount[g]-1]
					)
			
				join selectionArray  #( selectionArraySub = #( listBG[NameIndex][1] ) )
				join selectionArraySub #( listBG[NameIndex][2] )

				if ( listBG[NameIndex][2] == "tex" ) then (
					try ( edtMat.text = listBG[NameIndex][1].filename ) catch ( edtMat.text = "Warning: empty bitmap texture!" )
					) else if ( superClassOf listBG[NameIndex][1] == Material ) then (
						edtMat.text = listBG[NameIndex][1].name
						)
			) else (
				MessageBox ("Material or map \"" + edtBox.text + "\" not found...") title:ProgramName
				)
		) else (
			MessageBox "Please type a material or map name in the text field!" title:ProgramName
			)
	)
	
--text field
-------------------------------------		
on edtBox entered input do (
	searchByName input
	)

--search button
-------------------------------------
on btnSeMat pressed do (
	searchByName edtBox.text
	)
	
) --rollout end

	createDialog SearchMaterialAndMaps style:#( #style_titlebar, #style_border, #style_sysmenu, #style_resizing )
	cui.RegisterDialogBar SearchMaterialAndMaps minSize:[150, 100] maxSize:[-1, 1200] style:#( #cui_dock_vert, #cui_floatable, #cui_handles )
) --script end

)