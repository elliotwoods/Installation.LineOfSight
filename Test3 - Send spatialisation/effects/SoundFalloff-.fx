//@author: elliotwoods
//@help: apply sound falloff to source
//@tags: panning, spatialisation
//@credits:

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

//transforms
float4x4 tW: WORLD;        //the models world matrix
float4x4 tV: VIEW;         //view matrix as set via Renderer (EX9)
float4x4 tP: PROJECTION;   //projection matrix as set via Renderer (EX9)
float4x4 tWVP: WORLDVIEWPROJECTION;


//texture
float4x4 tRoom <string uiname="Room Transform";>;
float4x4 tObjectInverse <string uiname="Inverse Object Transform";>;

//the data structure: vertexshader to pixelshader
//used as output data with the VS function
//and as input data with the PS function
struct vs2ps
{
    float4 Pos : POSITION;
    float4 TexCd : TEXCOORD0;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------

vs2ps VS(
    float4 Pos : POSITION,
    float4 TexCd : TEXCOORD0)
{
    //inititalize all fields of output struct with 0
    vs2ps Out = (vs2ps)0;

    //transform position
    Out.Pos = mul(Pos, tW);
	Out.Pos.xy *= 2.0f;

    //transform texturecoordinates
    Out.TexCd = TexCd;
	//Out.TexCd.xy -= 0.5f;

    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------

float Radius = 1.0f;

float4 PS(vs2ps In): COLOR
{
	float4 PosRoom;
	PosRoom.xz = In.TexCd.xy;
	PosRoom.y = 0.5f;
	PosRoom.w = 1.0f;
	
	return PosRoom;
	
	float4 PosWorld = mul(PosRoom, tRoom);
	PosWorld /= PosWorld.w;
	
	float4 PosObject = mul(PosWorld, tObjectInverse);
	PosObject /= PosObject.w;
	
	float r = length(PosObject.xyz);
	
    return 0.0f;//Radius / r;
}

// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique TConstant
{
    pass P0
    {
        Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader = compile ps_3_0 PS();
    }
}
