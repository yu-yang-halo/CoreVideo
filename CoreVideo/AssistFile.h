#include <string>
#include <vector>
#include <stdlib.h>
#include <limits.h>
#include <stdio.h>
#pragma once

using namespace std;

//Novatek GPS tracker info
#define UINT32 unsigned int
typedef enum {
	SHAKE_L,
	SHAKE_R,
}SHAKE;

typedef enum {
	ORIENT_0,
	ORIENT_90,
	ORIENT_180,
	ORIENT_270,
}ORIENT;

typedef struct {
	UINT32 Xacc;
	UINT32 Yacc;
	UINT32 Zacc;
}AXIS_DATA;

typedef struct {
	AXIS_DATA Axis;
	ORIENT    Ori;
	SHAKE	  SH;
}Gsensor_Data, *pGsensor_Data;

//RMC, Recommended Minimum sentence C
typedef struct{

	UINT32    Hour;
	UINT32    Minute;
	UINT32    Second;
	char      Status;              //Status A=active or V=Void
	double     Latitude;
	char      NSInd;
	double     Longitude;
	char      EWInd;
	double     Speed;               //Speed over the ground in knots
	double    Angle;               //Track angle in degrees True
	UINT32    Year;
	UINT32    Month;
	UINT32    Day;

	int    Xacc;
	int    Yacc;
	int    Zacc;
	char   Gps_str[128];
	char   key[10];
}RMCINFO;

//For Sunplus
typedef struct gps_mov_data {	
	short gsensor_x;
	short gsensor_y;
	short gsensor_z;

	char  gps_info_rmc[126];
}sunplus_gps_mov_data_t;

typedef struct tagAssistInfo {
	float	gsensor_x;
	float	gsensor_y;
	float	gsensor_z;
	string  gps_lat;
	string  gps_lgt;
	int     spd;
	double  north_angle;
}AssistInfo_t, *PAssistInfo;

typedef vector<AssistInfo_t>	AssistInfoList;
class CAssistFile
{
public:
	CAssistFile(void);
	~CAssistFile(void);

private:
	string m_strAstFile;
	
	AssistInfoList	m_infoList;


	int ParseGGA(char *gpsinfo, string &strLat, string &strLgt, int &spd);
	int ParseRMC(char *gpsinfo, string &strLat, string &strLgt, int &spd, double &north_angle);
	int ParseLine(char *pszLine, int key);
public:
	#define ENDIAN_CONV(b)	(b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3])
	int ParseAssistFile(string strAstFile);
	int ParseAssistDataForSunplus(string strMOVFile);		//2013-03-04
	int ParseMOVSubtitle(string strMOVFile);				//2013-06-17  for A7s mov
	int ParseAssistDataForNovatek(string strMOVFile);		//2013-08-19  for NTK mov

	int GetAssistInfoCount() { return m_infoList.size();}
	int GetNode(int idx, AssistInfo_t &node);

	void ClearList();
	AssistInfoList* GetAssistInfoList(void) {return &m_infoList;}

};
