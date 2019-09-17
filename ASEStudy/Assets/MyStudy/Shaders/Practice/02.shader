// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SLPractice/02"
{
	Properties
	{
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		_FlipBook("FlipBook", Vector) = (3,3,1,0)
		[Enum(Time,0,Frame,1)]_FlipBook_Time("FlipBook_Time", Float) = 0
		_Frame("Frame", Float) = 0
	}
	
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM

#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
		//only defining to not throw compilation error over Unity 5.5
		#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
#endif
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			};

			uniform half4 _MainColor;
			uniform sampler2D _MainTex;
			uniform half4 _FlipBook;
			uniform half _Frame;
			uniform half _FlipBook_Time;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv05 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float lerpResult27 = lerp( _Time.y , _Frame , _FlipBook_Time);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles23 = _FlipBook.x * _FlipBook.y;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset23 = 1.0f / _FlipBook.x;
				float fbrowsoffset23 = 1.0f / _FlipBook.y;
				// Speed of animation
				float fbspeed23 = lerpResult27 * _FlipBook.z;
				// UV Tiling (col and row offset)
				float2 fbtiling23 = float2(fbcolsoffset23, fbrowsoffset23);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex23 = round( fmod( fbspeed23 + _FlipBook.w, fbtotaltiles23) );
				fbcurrenttileindex23 += ( fbcurrenttileindex23 < 0) ? fbtotaltiles23 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox23 = round ( fmod ( fbcurrenttileindex23, _FlipBook.x ) );
				// Multiply Offset X by coloffset
				float fboffsetx23 = fblinearindextox23 * fbcolsoffset23;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy23 = round( fmod( ( fbcurrenttileindex23 - fblinearindextox23 ) / _FlipBook.x, _FlipBook.y ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy23 = (int)(_FlipBook.y-1) - fblinearindextoy23;
				// Multiply Offset Y by rowoffset
				float fboffsety23 = fblinearindextoy23 * fbrowsoffset23;
				// UV Offset
				float2 fboffset23 = float2(fboffsetx23, fboffsety23);
				// Flipbook UV
				half2 fbuv23 = uv05 * fbtiling23 + fboffset23;
				// *** END Flipbook UV Animation vars ***
				float2 vertexToFrag30 = fbuv23;
				o.ase_texcoord.xy = vertexToFrag30;
				
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue =  float3(0,0,0) ;

				v.vertex.xyz += vertexValue;

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 vertexToFrag30 = i.ase_texcoord.xy;
				
				
				finalColor = ( _MainColor * tex2D( _MainTex, vertexToFrag30 ) * i.ase_color );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
7;7;1906;1004;1458.644;148.786;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;28;-1114.047,668.4489;Half;False;Property;_FlipBook_Time;FlipBook_Time;3;1;[Enum];Create;True;2;Time;0;Frame;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;26;-1135.944,427.3376;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1082.276,574.3386;Half;False;Property;_Frame;Frame;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1016.081,98.8618;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;25;-1019.944,243.3376;Half;False;Property;_FlipBook;FlipBook;2;0;Create;True;0;0;False;0;3,3,1,0;3,3,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;-842.0466,451.4489;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;23;-652.9438,100.3376;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.VertexToFragmentNode;30;-337.644,106.214;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;4;54.95589,287.6129;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-9,-96;Half;False;Property;_MainColor;MainColor;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-65,81;Float;True;Property;_MainTex;MainTex;1;1;[NoScaleOffset];Create;True;0;0;False;0;None;6b2910686f14f5844bf4707db2d5e2ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;261,63;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;447,63;Half;False;True;2;Half;ASEMaterialInspector;0;1;SLPractice/02;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;27;0;26;2
WireConnection;27;1;13;0
WireConnection;27;2;28;0
WireConnection;23;0;5;0
WireConnection;23;1;25;1
WireConnection;23;2;25;2
WireConnection;23;3;25;3
WireConnection;23;4;25;4
WireConnection;23;5;27;0
WireConnection;30;0;23;0
WireConnection;2;1;30;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;1;2;4;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=0B8C130D8F19D706B50E31D12BDD9002CFF19B80