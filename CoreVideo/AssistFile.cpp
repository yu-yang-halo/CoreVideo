#include <string>
#include <list>
#include <stdlib.h>
#include "AssistFile.h"
extern "C" int __cdecl _fseeki64(FILE *, int64_t, int);
extern "C" int64_t __cdecl _ftelli64(FILE *);

CAssistFile::CAssistFile(void)
{
}

CAssistFile::~CAssistFile(void)
{
	m_infoList.empty();
}

void decryt(char *szline, int key)
{
	int len = strlen(szline);
	int pos = 0;
	char *p = szline;

	while(len) {
		if(p[pos] == 0x0A || p[pos] == 0x0D) break;
		p[pos] = p[pos] - key;				
		pos ++;
		len--;
	}
    printf(p);
}

void parse_coordinate(char *coord, char dir, string &strCoord)
{
	int flag = 1;
	if(dir == 'W' || dir == 'S') flag = -1;
	int len = strlen(coord);
	char * dotPtr = strchr(coord, '.');	

	if(dotPtr) {
		int dddmm = 0;
		int ddd   = 0;
		float ssss = 0.0f;		
		float mmssss = 0.0f;
		int dotPos = dotPtr - coord;
		int degree_of_data = len - dotPos;

		coord[dotPos] = '\0';

		dddmm =atof(coord);
		if(dotPos + 1 < len - 1) {
			ssss  = atof(&coord[dotPos+1]);
		} else {
			ssss  = 0.0f;
		}
		//2231.0760 = 22 + 0.310760 * 100 / 60 = 22.5179333333
		ddd = dddmm / 100;
/*
		if(degree_of_data == 5){
			mmssss = dddmm % 100 * 10000 + ssss;
			strCoord.Format(_T("%d.%06d"),  ddd * flag, (int)mmssss * 100 / 60);
		}else if(degree_of_data == 6){
			mmssss = dddmm % 100 * 100000 + ssss;
			strCoord.Format(_T("%d.%07d"),  ddd * flag, (int)mmssss * 100 / 60);
		}
*/
		if(degree_of_data == 5){
			mmssss = dddmm % 100 * 10000 + ssss;
			if(flag < 0) {
				strCoord.Format("-%d.%06d",  ddd, (int)mmssss * 100 / 60);
                
			} else {
				strCoord.Format(_T("%d.%06d"),  ddd, (int)mmssss * 100 / 60);
			}			
		}else if(degree_of_data == 6){
			mmssss = dddmm % 100 * 100000 + ssss;
			if(flag < 0) {
				strCoord.Format(_T("-%d.%07d"),  ddd, (int)mmssss * 100 / 60);
			} else {
				strCoord.Format(_T("%d.%07d"),  ddd, (int)mmssss * 100 / 60);
			}			
		}	
	} else {
		strCoord = _T("0");
	}
}

int CAssistFile::ParseRMC(char *gpsinfo, CString &strLat, CString &strLgt, int &spd, double &north_angle)
{
	//$GPRMC,053014.000,A,2237.4177,N,11403.4075,E,1.90,235.83,050510,,,A*6B
	char *p = NULL;
	char lat[32] = {0};
	char lgt[32] = {0};
	char speed[32] = {0};
	char nangle[32] = {0};
	char lat_dir = 'N';
	char lgt_dir = 'E';	

	do {
		p = strtok(gpsinfo, ",");
		if(!p) break;
		if(strcmp(p, "$GPRMC") != 0) {
			break;
		}

		p = strtok(NULL, ",");		//<1> UTC Time
		if(!p) break;

		p = strtok(NULL, ",");		//<2> Valid flag  A: Valid  V: Invalid
		if(!p) break;

		p = strtok(NULL, ",");		//<3> lat
		if(!p || strlen(p) > 32) break;
		sprintf(lgt, "%s", p);

		p = strtok(NULL, ",");		//<4> lat dir
		if(!p) break;
		lgt_dir = p[0];

		p = strtok(NULL, ",");		//<5> lgt
		if(!p || strlen(p) > 32) break;
		sprintf(lat, "%s", p);

		p = strtok(NULL, ",");		//<6> lgt dir
		if(!p) break;
		lat_dir = p[0];

		p = strtok(NULL, ",");		//<7> speed
		if(!p || strlen(p) > 32) break;
		sprintf(speed, "%s", p);

		p = strtok(NULL, ",");		//<8> north angle
		if(!p || strlen(p) > 32) break;
		sprintf(nangle, "%s", p);

		p = strtok(NULL, ",");		//<9> UTC Date

		CString str;
		parse_coordinate(lgt, lgt_dir, str);
		strLgt = str;
		parse_coordinate(lat, lat_dir, str);
		strLat = str;

		spd = (int)(atof(speed) * 1.85);
		north_angle = atof(nangle);
	}while(0);

	return 0;
}

int CAssistFile::ParseGGA(char *gpsinfo, CString &strLat, CString &strLgt, int &spd)
{
	//$GPGGA,071458.000,0000.0000,N,00000.0000,E,0,06,2.7,39.8,M,-2.7,M,,0000*7F
	char *p = NULL;
	char lat[32] = {0};
	char lgt[32] = {0};
	char lat_dir = 'N';
	char lgt_dir = 'E';	
	    
	do {
		p = strtok(gpsinfo, ",");
		if(!p) break;
		if(strcmp(p, "$GPGGA") != 0) {
			break;
		}

		p = strtok(NULL, ",");		//Time?
		if(!p) break;

		p = strtok(NULL, ",");		//lgt
		if(!p || strlen(p) > 32) break;
		sprintf(lgt, "%s", p);
		
		p = strtok(NULL, ",");		//lgt dir
		if(!p) break;
		lgt_dir = p[0];

		p = strtok(NULL, ",");		//lat
		if(!p || strlen(p) > 32) break;
		sprintf(lat, "%s", p);

		p = strtok(NULL, ",");		//lat dir
		if(!p) break;
        lat_dir = p[0];
	
		CString str;
		parse_coordinate(lgt, lgt_dir, str);
		strLgt = str;
		parse_coordinate(lat, lat_dir, str);
		strLat = str;

	}while(0);

	return 0;
}

int CAssistFile::ParseLine(char *pszLine, int key)
{
	int				x, y, z;
	char gpsinfo[1024] = {0};

	AssistInfo_t	node;	
	node.gsensor_x = 0.0f;
	node.gsensor_y = 0.0f;
	node.gsensor_z = 0.0f;
	node.north_angle = 0.0f;
	node.spd = 0;
		
	x = y = z = 0;
	if(!pszLine) return -1;
		
	TRACE("Line:%s\n", pszLine);
	decryt(pszLine, key);
	TRACE("    :%s\n", pszLine);
	sscanf(pszLine, "%d\t%d\t%d\t%s", &x, &y, &z, gpsinfo);			
	node.gsensor_x = x / 1000.0f;
	node.gsensor_y = y / 1000.0f;
	node.gsensor_z = z / 1000.0f;
	if(gpsinfo[0] == '$' && gpsinfo[1] == 'G' && gpsinfo[2] == 'P' && gpsinfo[3] == 'G' && gpsinfo[4] == 'G' && gpsinfo[5] == 'A') {
		ParseGGA(gpsinfo, node.gps_lat, node.gps_lgt, node.spd);		//GPS info
	} else {
		ParseRMC(gpsinfo, node.gps_lat, node.gps_lgt, node.spd, node.north_angle);
	}	

	m_infoList.AddTail(node);
#if 1	//模拟文件以1Hz采样,实际是用10Hz采样
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);
	m_infoList.AddTail(node);		
#endif
	do {
		
	}while(0);

	return 0;
}
int CAssistFile::ParseAssistFile(CString strAstFile)
{
	TCHAR	tFile[MAX_PATH]	 = {0};
	char	szFile[MAX_PATH] = {0};
	char	szLine[1024]		 = {0};	
	FILE	*fd				 = NULL;		
	
	USES_CONVERSION;

	//Convert TCHAR to CHAR
	wsprintf(tFile, _T("%s"), strAstFile);
	sprintf(szFile, "%s", T2A(tFile));

	//Clear list first
	m_infoList.RemoveAll();

	if(strAstFile.GetLength() < 4) return -1;

	//Open file
	fd = fopen(szFile, "rb");
	if(!fd) {
		return -1;
	}

	int key = 0;
	if(fgets(szLine, 1024, fd)) {		//get first line (KEY)
		char ch;
		ch = szLine[0];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[1];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[2];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[3];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[4];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[4];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[5];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[6];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);
		ch = szLine[7];
		if(atoi(&ch) == 0) goto end;
		key += atoi(&ch);		
		ch = szLine[7];
		key += atoi(&ch);
		while(fgets(szLine, 1024, fd)) {
			ParseLine(szLine, key);
		}
	}	

end:
	fclose(fd);
	fd = NULL;	
	
	return m_infoList.GetCount();
}

#define POS(x)  (7+x)
int CAssistFile::ParseAssistDataForSunplus(CString strMOVFile)
{
	TCHAR	tFile[MAX_PATH]	 = {0};
	char	szFile[MAX_PATH] = {0};
	char	szLine[1024]		 = {0};	
	FILE	*fd				 = NULL;	
	char	dat_hdr_flag[17] = {'\0'};

	USES_CONVERSION;

	//Convert TCHAR to CHAR
	wsprintf(tFile, _T("%s"), strMOVFile);
	sprintf(szFile, "%s", T2A(tFile));
	//Clear list first
	m_infoList.RemoveAll();

	if(strMOVFile.GetLength() < 4) return -1;

	//Open file
	fd = fopen(szFile, "rb");
	if(fd == NULL) {
		return -1;
	}

	/****************sunplus mov file struct ***************************************
	   [ftypSize][ftyp]
	       [mdatSize][mdat]......     --->所有音视频数据
		   [moovSize][moov]......     --->文件数据头及索引
		   [udatSize][udat]......     --->用户数据
		   [flagSize][icat6330]       --->sunplus加的文件标识
   ********************************************************************************/

	unsigned int ftypsize = 0, mdatsize = 0, moov_addr = 0, moovsize = 0, udat_addr = 0, udatsize = 0;
	unsigned char b[4] = {0};
	int found_flag = 0;

	fread((unsigned char*)b, 1, 4, fd);		//get mdat address(ftyp size)
	ftypsize = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
	if(ftypsize > 0) {
		_fseeki64(fd, ftypsize, SEEK_SET);			
		TRACE(_T("mdat_addr: 0x%08X\n"), ftypsize);
		
		fread((unsigned char*)b, 1, 4, fd); //get mdat size
		mdatsize = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];		
		if(mdatsize > 0) {
			moov_addr = mdatsize + ftypsize;  
			_fseeki64(fd, moov_addr, SEEK_SET);
			TRACE(_T("moov_addr: 0x%08X\n"), moov_addr);
			fread((unsigned char*)b, 1, 4, fd); //get moov size
			moovsize = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
			if(moovsize > 0) {				
				udat_addr = moov_addr + moovsize;
				_fseeki64(fd, udat_addr, SEEK_SET);
				TRACE(_T("udat_addr: 0x%08X, moovsize:0x%08X\n"), udat_addr, moovsize);

				fread((unsigned char*)b, 1, 4, fd); //get udat size
				udatsize = b[0] << 24 | b[1] << 16 | b[2] << 8 | b[3];
				if(udatsize > 0) {
					TRACE(_T("udatSize: 0x%08X\n"), udatsize);
					//_fseeki64(fd, 4, SEEK_CUR);		//skip 'udat'
					if(fread(dat_hdr_flag, 1, 4, fd) == 4) {
						if(dat_hdr_flag[0] == 'f' && dat_hdr_flag[1] == 'r' && dat_hdr_flag[2] == 'e' && dat_hdr_flag[3] == 'e') {
							udat_addr += udatsize;
							_fseeki64(fd, udat_addr + 8, SEEK_SET); //8: udat flag + udat size
						}
						if(fread(dat_hdr_flag, 1, 16, fd) == 16) {
							dat_hdr_flag[15] = '\0';
							TRACE("data:%s\n", dat_hdr_flag);
							if(dat_hdr_flag[0] == 's' && dat_hdr_flag[1] == 'a' && dat_hdr_flag[2] == 'm' && dat_hdr_flag[3] == 'o'
								&& dat_hdr_flag[4] == 'o' && dat_hdr_flag[5] == 'n' && dat_hdr_flag[6] == '1') 
							{		//"samoon1"
								//if(strcmp(dat_hdr_flag, "samoon01") == 0) {
								found_flag = 1;							
							}
						}
					}					
				}
			}
		}
	}
			
	if(found_flag) 
	{
		sunplus_gps_mov_data_t gps_dat;
		unsigned char key = 0;
		char ch;

		//value = Matrix[0]+Matrix[1]+Matrix[2]+Matrix[3]+Matrix[4]+ Matrix[4]+Matrix[5]+Matrix[6]+Matrix[7]+Matrix[7];			
		key = dat_hdr_flag[POS(0)] + dat_hdr_flag[POS(1)] + dat_hdr_flag[POS(2)] + dat_hdr_flag[POS(3)] + dat_hdr_flag[POS(4)] + dat_hdr_flag[POS(4)] \
			+ dat_hdr_flag[POS(5)] + dat_hdr_flag[POS(6)] + dat_hdr_flag[POS(7)] + dat_hdr_flag[POS(7)];
		//TRACE("hdr:%s, key:%d \n", dat_hdr_flag, key);

		while(!feof(fd)) {
			if(fread((char*)&gps_dat, 1, sizeof(sunplus_gps_mov_data_t), fd) != sizeof(sunplus_gps_mov_data_t)) {
				break;
			}

			{ //decrypt gps data
				gps_dat.gsensor_x -= key;
				gps_dat.gsensor_y -= key;
				gps_dat.gsensor_z -= key;

				int i;
				for(i = 0; i < 126; i++) {
					gps_dat.gps_info_rmc[i] -= key;
				}
				dat_hdr_flag[16] = '\0';
				TRACE("Flag:%s KEY:%d x:%d y:%d z:%d rmc:%s \n", dat_hdr_flag, key, gps_dat.gsensor_x, gps_dat.gsensor_y, gps_dat.gsensor_z, gps_dat.gps_info_rmc);
			}

			AssistInfo_t	node;	
			node.gsensor_x = gps_dat.gsensor_x / 1000.0f;
			node.gsensor_y = gps_dat.gsensor_y / 1000.0f;
			node.gsensor_z = gps_dat.gsensor_z / 1000.0f;
			node.north_angle = 0.0f;
			node.spd = 0;
						
			ParseRMC(gps_dat.gps_info_rmc, node.gps_lat, node.gps_lgt, node.spd, node.north_angle);				

			m_infoList.AddTail(node);
#if 1	//模拟文件以1Hz采样,实际是用10Hz采样
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);
			m_infoList.AddTail(node);		
#endif

		}
	}

end:
	fclose(fd);
	fd = NULL;	

	return m_infoList.GetCount();
}

#if 0
int CAssistFile::ParseAssistDataForNovatek(CString strMOVFile)
{
	TCHAR	tFile[MAX_PATH]	 = {0};
	char	szFile[MAX_PATH] = {0};
	FILE	*fd				 = NULL;	
	char	szBuf[1024] = {0};
	char	file[MAX_PATH] = {0};
	int		flag	= 0;

	USES_CONVERSION;

	//Convert TCHAR to CHAR
	wsprintf(tFile, _T("%s"), strMOVFile);
	sprintf(szFile, "%s", T2A(tFile));
	//Clear list first
	m_infoList.RemoveAll();

	if(strMOVFile.GetLength() < 4) return -1;

	//Open file
	fd = fopen(szFile, "rb");
	if(fd == NULL) {
		return -1;
	}

	do{
		unsigned int ftypsize = 0, mdatsize = 0, mdat_addr = 0, moov_addr = 0, mvhd_addr = 0;
		unsigned int strm1 = 0, strm2 = 0, strm3 = 0;
		unsigned int tkhd = 0, edts = 0, mdia = 0;
		unsigned int mdhd = 0, dinf = 0, stbl = 0;
		unsigned int stsd = 0, stts = 0, stsc = 0, stsz = 0, stco = 0;
		unsigned int size = 0, pos = 0, curpos = 0;
		unsigned char chSize[8] = {0};
		char chFlag[12] = {0};
		char rbuf[128] = {0};
		char date_s[16] = {0};
		char time_s[16] = {0};
		char gps_lat[16] = {0};
		char gps_lgt[16] = {0};
		char gps_spd[16] = {0};
		int i, check_flag = 0;
		
		//Step1. Find MOOV
		check_flag = 0;
		while(!feof(fd)) {
			int offset = 0;
			if(fread(chSize, 1, 4, fd) != 4) break;		//get address
			size = ENDIAN_CONV(chSize);		//convert size			
			if(fread(chFlag, 1, 8, fd) != 8) break;

			offset += 12;
			//TRACE(" [0x%08X]%s\n", *((unsigned int*)chSize), chFlag);

			if(strcmp(chFlag, "freeGPS ") == 0) {
				int found_key = 0;
				int key = 0;
				RMCINFO gsdata;

				TRACE(" [0x%08X]%s\n", *((unsigned int*)chSize), chFlag);

				memset(&gsdata, 0, sizeof(RMCINFO));
				_fseeki64(fd, 36, SEEK_CUR);			//Offset 36
				offset += 36;
				
				fread((char*)&gsdata, 1, sizeof(RMCINFO), fd);
				offset += sizeof(RMCINFO);
				//gsdata.key[0] = 0x20;
				TRACE("size:%d, Year:%d, Mon:%d, Day:%d, Hour:%d, Min:%d, Sec:%d, x:%08X y:%08X z:%08X, key:%s\n",  
					sizeof(RMCINFO), gsdata.Year, gsdata.Month, gsdata.Day, gsdata.Hour, gsdata.Minute, gsdata.Second,
					gsdata.Xacc, gsdata.Yacc, gsdata.Zacc, gsdata.key);
			
				char num[2] = {0};
				key = 0;
				num[0] = gsdata.key[(0)]; key += atoi(num);
				num[0] = gsdata.key[(1)]; key += atoi(num);
				num[0] = gsdata.key[(2)]; key += atoi(num);
				num[0] = gsdata.key[(3)]; key += atoi(num);
				num[0] = gsdata.key[(4)]; key += atoi(num);
				num[0] = gsdata.key[(4)]; key += atoi(num);
				num[0] = gsdata.key[(5)]; key += atoi(num);
				num[0] = gsdata.key[(6)]; key += atoi(num);
				num[0] = gsdata.key[(7)]; key += atoi(num);
				num[0] = gsdata.key[(7)]; key += atoi(num);									
				//TRACE("  key:%d\n", key);

				{	//Decrypt
					int pos = 0, len = 128; //10 = sizeof(key)
					char *p = gsdata.Gps_str;

					while(len) {			
						if(len > 1 && p[pos] == 0x0D && p[pos+1] == 0x0A) {
							break;
						}
						p[pos] = p[pos] - key;				
						pos ++;
						len--;
					}
					//TRACE(" dectyped: x:%d, y:%d, z:%d, gps:%s\n",gsdata.Xacc, gsdata.Yacc, gsdata.Zacc, gsdata.Gps_str);

					AssistInfo_t	node;							
					node.north_angle = 0.0f;
					node.spd = 0;
					node.gsensor_x = gsdata.Xacc / 1000.0f;// * 64;
					node.gsensor_y = gsdata.Yacc / 1000.0f;// * 64;
					node.gsensor_z = gsdata.Zacc / 1000.0f;// * 64;
					if(gsdata.Gps_str[1] == '$' && gsdata.Gps_str[2] == 'G' && gsdata.Gps_str[3] == 'P' && gsdata.Gps_str[4] == 'G' && gsdata.Gps_str[5] == 'G' && gsdata.Gps_str[6] == 'A') {
						ParseGGA(&gsdata.Gps_str[1], node.gps_lat, node.gps_lgt, node.spd);		//GPS info
					} else {
						ParseRMC(&gsdata.Gps_str[1], node.gps_lat, node.gps_lgt, node.spd, node.north_angle);
					}	

					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);
					m_infoList.AddTail(node);		
				}
			}

			pos = (32*1024 - offset);
			_fseeki64(fd, pos, SEEK_CUR);
		}
	}while(0);
end:
	fclose(fd);
	fd = NULL;	
}
#else
int CAssistFile::ParseAssistDataForNovatek(CString strMOVFile)
{
	TCHAR	tFile[MAX_PATH]	 = {0};
	char	szFile[MAX_PATH] = {0};
	FILE	*fd				 = NULL;	
	char	szBuf[1024] = {0};
	char	file[MAX_PATH] = {0};
	int		flag	= 0;

	USES_CONVERSION;

	//Convert TCHAR to CHAR
	wsprintf(tFile, _T("%s"), strMOVFile);
	sprintf(szFile, "%s", T2A(tFile));
	//Clear list first
	m_infoList.RemoveAll();

	if(strMOVFile.GetLength() < 4) return -1;

	//Open file
	fd = fopen(szFile, "rb");
	if(fd == NULL) {
		return -1;
	}

    //moov
	//idx1
	//1. Get MOOV offset
	//2. Get audio tracker offset
	//3.    Get 01wb offset from idx1
	//4.    Get GS_data in moov by 01wb offset + 1 sdcard cluster size(0x10000)

	do {
		unsigned int ftypsize = 0, mdatsize = 0, mdat_addr = 0, moov_addr = 0, mvhd_addr = 0;
		unsigned int strm1 = 0, strm2 = 0, strm3 = 0;
		unsigned int tkhd = 0, edts = 0, mdia = 0;
		unsigned int mdhd = 0, dinf = 0, stbl = 0;
		unsigned int stsd = 0, stts = 0, stsc = 0, stsz = 0, stco = 0;
		unsigned int size = 0, pos = 0, curpos = 0;
		unsigned char chSize[8] = {0};
		char chFlag[8] = {0};
		char rbuf[128] = {0};
		char date_s[16] = {0};
		char time_s[16] = {0};
		char gps_lat[16] = {0};
		char gps_lgt[16] = {0};
		char gps_spd[16] = {0};
		int i, check_flag = 0;

		//Step1. Find MOOV
		check_flag = 0;
		while(!feof(fd)) {
			if(fread(chSize, 1, 4, fd) != 4) break;		//get address
			size = ENDIAN_CONV(chSize);		//convert size			
			if(fread(chFlag, 1, 4, fd) != 4) break;

			pos += size;
			TRACE(" [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);

			if(strcmp(chFlag, "mdat") == 0) {
				mdat_addr = _ftelli64(fd);
			}
			if(strcmp(chFlag, "moov") == 0) {
				check_flag = 1;
				curpos = _ftelli64(fd);
				break;
			}

			_fseeki64(fd, size-8, SEEK_CUR);
		}
		if(check_flag == 0) break;

		//Step2. Get Tracker
		int track_id = 0;	
		check_flag = 0;
		while(!feof(fd)) {
			if(fread(chSize, 1, 4, fd) != 4) break;		//get address
			size = ENDIAN_CONV(chSize);		//convert size			
			if(fread(chFlag, 1, 4, fd) != 4) break;

			pos += size;
			TRACE("         [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);		

			if(track_id > 0 && strcmp(chFlag, "trak") != 0) {	//only 1 track
				check_flag = 1;
				_fseeki64(fd, curpos, SEEK_SET);
			}
			if(strcmp(chFlag, "trak") == 0) {
				curpos = _ftelli64(fd);
				track_id ++;
				if(track_id == 2) {		//track1: video, track2: audio
					check_flag = 1;					
				}				
			}

			if(check_flag == 1) {
				//Step3. Check Tracker
				do {					
					//Step4. Get mdia from trak
					int check_flag2 = 0;
					while(_ftelli64(fd) <= pos) {
						if(fread(chSize, 1, 4, fd) != 4) break;		//get address
						size = ENDIAN_CONV(chSize);		//convert size			
						if(fread(chFlag, 1, 4, fd) != 4) break;

						TRACE("                [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
						if(strcmp(chFlag, "mdia") == 0) {
							check_flag2 = 1;
							break;
						}
						_fseeki64(fd, size-8, SEEK_CUR);
					}
					if(check_flag2 == 0) break;

					//Step5. Get minf from mdia
					check_flag2 = 0;
					while(_ftelli64(fd) <= pos) {
						if(fread(chSize, 1, 4, fd) != 4) break;		//get address
						size = ENDIAN_CONV(chSize);		//convert size			
						if(fread(chFlag, 1, 4, fd) != 4) break;

						TRACE("                        [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
						if(strcmp(chFlag, "minf") == 0) {
							check_flag2 = 1;
							break;
						}
						_fseeki64(fd, size-8, SEEK_CUR);
					}
					if(check_flag2 == 0) break;

					//Step6. Get stbl from minf
					check_flag2 = 0;
					while(_ftelli64(fd) <= pos) {
						if(fread(chSize, 1, 4, fd) != 4) break;		//get address
						size = ENDIAN_CONV(chSize);		//convert size			
						if(fread(chFlag, 1, 4, fd) != 4) break;

						TRACE("                                [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
						if(strcmp(chFlag, "stbl") == 0) {
							check_flag2 = 1;
							break;
						}
						_fseeki64(fd, size-8, SEEK_CUR);
					}
					if(check_flag2 == 0) break;

					//Step7. Get stsz from stbl
					check_flag2 = 0;
					while(_ftelli64(fd) <= pos) {
						if(fread(chSize, 1, 4, fd) != 4) break;		//get address						
						if(fread(chFlag, 1, 4, fd) != 4) break;
						size = ENDIAN_CONV(chSize);		//convert size
						TRACE("                                        [0x%08X]% 4d-%s - Pos:0x%08X\n", *((unsigned int*)chSize), size, chFlag, pos);
						if((track_id == 1 && strcmp(chFlag, "stsz") == 0)
							|| ((track_id > 1 && strcmp(chFlag, "stco") == 0))) {
							check_flag2 = 1;
							break;
						}									
						_fseeki64(fd, size-8, SEEK_CUR);
					}
					if(check_flag2 == 0) break;
					
					unsigned int stsz_addr = _ftelli64(fd);
					unsigned int stsz_size = size;
					unsigned int addr = 0;
					unsigned int *alladdr;
					int gps_rec_cnt = 0;
										
					if(track_id == 1) {	//only video tracker
						size = (size - 8) / 4;					  //4bytes for every frame size length
						if(size > 0) {
							gps_rec_cnt = size / 30 + 1;
							alladdr = (unsigned int *)malloc(gps_rec_cnt * sizeof(unsigned int));
						} else {
							break;
						}
						TRACE("	Founded %d stsz indexs! mdat_addr:0x%08X, curr:0x%08X\n", size, mdat_addr, _ftelli64(fd));
						
						//Step8. Read video frame size from STSZ
						_fseeki64(fd, 8, SEEK_CUR);	//Skip the first 8 bytes
						for(i = 0; i < size; i++) {
							unsigned int addr = 0, rval = 0, idx;
							memset(chSize, 0, 8);
							fread(chSize, 1, 4, fd);
							addr = ENDIAN_CONV(chSize);
							//TRACE("STSZ    idx%d: 0x%08X\n", i, addr);
							
							idx = (i + 1) / 30;
							if(i > 0 && (i % 30) == 0) {	//Read video frame size by every 30fps(at the 31frame)							
								alladdr[idx - 1] = addr;		//video frame size
								TRACE("\tSTSZ    idx%d: 0x%08X\n", idx, addr);
							}							
						}

						//Read video frame offset from STCO
						_fseeki64(fd, stsz_addr + stsz_size - 8, SEEK_SET);
						if(fread(chSize, 1, 4, fd) != 4) break;   //[4] size
						if(fread(chFlag, 1, 4, fd) != 4) break;   //[4] flag
						size = ENDIAN_CONV(chSize);
						size = (size - 8) / 4;
						if(size > 0) {
							TRACE("	Founded %d %s indexs(0x%08X)! mdat_addr:0x%08X, curr:0x%08X\n", size, chFlag, stsz_addr, mdat_addr, _ftelli64(fd));
							//Read video frame size from STCO
							_fseeki64(fd, 8, SEEK_CUR);	//Skip the first 8 bytes
							for(i = 0; i < size; i++) {
								unsigned int addr = 0, rval = 0, idx;
								memset(chSize, 0, 8);
								fread(chSize, 1, 4, fd);	
								addr = ENDIAN_CONV(chSize);
								//TRACE("STCO    idx%d: 0x%08X\n", i, addr);

								idx = (i + 1) / 30;
								if(i > 0 && ((i + 1) % 30) == 0 && idx <= gps_rec_cnt) {	//Read video frame offset by every 30fps(at the 30frame!!!! Fuck!!!!)									
									addr = alladdr[idx-1] + addr; //Video frame size + Video frame offset
									addr = ((addr + 0x7fff) & 0xFFFF8000);		//Aligned to 0x8000(For wirte cluster size)
									alladdr[idx-1] = addr;		
									TRACE("\tSTCO    idx%d: 0x%08X\n", idx, addr);									
								}					
							}
						}
					} else {
						//Step8. Get index from stco	
						if(fread(chSize, 1, 4, fd) != 4) break;   //[4]
						if(fread(chSize, 1, 4, fd) != 4) break;   //[4] index size		
						size = ENDIAN_CONV(chSize);
						if(size > 0) {
							alladdr = (unsigned int *)malloc((size + 1)*sizeof(unsigned int));
						}
						TRACE("	Founded %d indexs! mdat_addr:0x%08X, curr:0x%08X\n", size, mdat_addr, _ftelli64(fd));
						for(i = 0; i < size; i++) {
							unsigned int addr = 0, rval = 0;
							memset(chSize, 0, 8);
							fread(chSize, 1, 4, fd);								
							addr = ENDIAN_CONV(chSize);
							//alladdr[i] = addr; //Skip 0x00 0x35
							//alladdr[i] = addr + 0x20000; //0x10000: cluster size: 128K   立体声: 0x20000
							alladdr[i] = addr + 0x10000; //cluster size: 128K   单声道: 0x10000
							TRACE("    idx%d: 0x%08X\n", i, addr);
						}
						gps_rec_cnt = size;
					}
					
#if 1
					int found_key = 0;
					int key = 0;
					char cache[20][128] = {0};
					for(i = 0; i < gps_rec_cnt; i++) {			
						int len;

						RMCINFO gsdata;
						memset(&gsdata, 0, sizeof(RMCINFO));
						_fseeki64(fd, alladdr[i] + 48/*72 Fuck!!!*/, SEEK_SET);						
						fread((char*)&gsdata, 1, sizeof(RMCINFO), fd);
						
						char num[2] = {0};
						key = 0;
						num[0] = gsdata.key[(0)]; key += atoi(num);
						num[0] = gsdata.key[(1)]; key += atoi(num);
						num[0] = gsdata.key[(2)]; key += atoi(num);
						num[0] = gsdata.key[(3)]; key += atoi(num);
						num[0] = gsdata.key[(4)]; key += atoi(num);
						num[0] = gsdata.key[(4)]; key += atoi(num);
						num[0] = gsdata.key[(5)]; key += atoi(num);
						num[0] = gsdata.key[(6)]; key += atoi(num);
						num[0] = gsdata.key[(7)]; key += atoi(num);
						num[0] = gsdata.key[(7)]; key += atoi(num);									
						//TRACE("  key:%d\n", key);

						{	//Decrypt
							int pos = 0, len = 128; //10 = sizeof(key)
							char *p = gsdata.Gps_str;

							while(len) {			
								if(len > 1 && p[pos] == 0x0D && p[pos+1] == 0x0A) {
									break;
								}
								p[pos] = p[pos] - key;				
								pos ++;
								len--;
							}
							TRACE("[%d] dectyped: x:%d, y:%d, z:%d, gps:%s\n", i, gsdata.Xacc, gsdata.Yacc, gsdata.Zacc, gsdata.Gps_str);

							AssistInfo_t	node;							
							node.north_angle = 0.0f;
							node.spd = 0;
							if(((gsdata.Xacc>10000)||(gsdata.Xacc<-10000))||((gsdata.Yacc>10000)||(gsdata.Yacc<-10000))||((gsdata.Zacc>10000)||(gsdata.Zacc<-10000)))//MI@20141121  Update Time Lapse Video Issue  
							{
								gsdata.Xacc = 0;
								gsdata.Yacc = 0;
								gsdata.Zacc = 0;
							}

							node.gsensor_x =gsdata.Xacc / 1000.0f;// * 64;
							node.gsensor_y =gsdata.Yacc / 1000.0f;// * 64;
							node.gsensor_z =gsdata.Zacc / 1000.0f;// * 64;

							if(gsdata.Gps_str[1] == '$' && gsdata.Gps_str[2] == 'G' && gsdata.Gps_str[3] == 'P' && gsdata.Gps_str[4] == 'G' && gsdata.Gps_str[5] == 'G' && gsdata.Gps_str[6] == 'A') {
								ParseGGA(&gsdata.Gps_str[1], node.gps_lat, node.gps_lgt, node.spd);		//GPS info
							} else {
								ParseRMC(&gsdata.Gps_str[1], node.gps_lat, node.gps_lgt, node.spd, node.north_angle);
							}	

							m_infoList.AddTail(node);
#if 1	//模拟文件以1Hz采样,实际是用10Hz采样
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);
							m_infoList.AddTail(node);		
#endif
						}

					}	
#endif
					if(alladdr != NULL) {
						free(alladdr);
						alladdr = NULL;
					}
					break;
				}while(0);

				_fseeki64(fd, curpos, SEEK_SET);

				break;
			}
			_fseeki64(fd, size-8, SEEK_CUR);			
		}		
	}while(0);

end:
	fclose(fd);
	fd = NULL;	

	return m_infoList.GetCount();
}
#endif

//@20130627
int CAssistFile::ParseMOVSubtitle(CString strMOVFile)
{
	TCHAR	tFile[MAX_PATH]	 = {0};
	char	szFile[MAX_PATH] = {0};
	FILE	*fd				 = NULL;	
	char	szBuf[1024] = {0};
	char	file[MAX_PATH] = {0};
	int		flag	= 0;

	USES_CONVERSION;

	//Convert TCHAR to CHAR
	wsprintf(tFile, _T("%s"), strMOVFile);
	sprintf(szFile, "%s", T2A(tFile));
	//Clear list first
	m_infoList.RemoveAll();

	if(strMOVFile.GetLength() < 4) return -1;

	//Open file
	fd = fopen(szFile, "rb");
	if(fd == NULL) {
		return -1;
	}

	//moov
	//   mvhd
	//   trak (video)
	//   trak (audio)
	//   trak (text)
	//       tkhd
	//       edts
	//       mdia
	//           mdhd
	//           hdlr
	//           minf
	//               nmhd
	//               dinf
	//               stbl
	//                   stsd
	//                   stts
	//                   stsc
	//                   stsz
	//                   stco
	//                       subtitle idx(4bytes address)
	//1. Get MOOV
	//2. Get Strm Text
	//3. Get STCO

	do {
		unsigned int ftypsize = 0, mdatsize = 0, moov_addr = 0, mvhd_addr = 0;
		unsigned int strm1 = 0, strm2 = 0, strm3 = 0;
		unsigned int tkhd = 0, edts = 0, mdia = 0;
		unsigned int mdhd = 0, dinf = 0, stbl = 0;
		unsigned int stsd = 0, stts = 0, stsc = 0, stsz = 0, stco = 0;
		unsigned int size = 0, pos = 0, curpos = 0;
		unsigned char chSize[8] = {0};
		char chFlag[8] = {0};
		char rbuf[128] = {0};
		char date_s[16] = {0};
		char time_s[16] = {0};
		char gps_lat[16] = {0};
		char gps_lgt[16] = {0};
		char gps_spd[16] = {0};
		int i, check_flag = 0;

		//Step1. Find MOOV
		check_flag = 0;
		while(!feof(fd)) {
			if(fread(chSize, 1, 4, fd) != 4) break;		//get address
			size = ENDIAN_CONV(chSize);		//convert size			
			if(fread(chFlag, 1, 4, fd) != 4) break;

			pos += size;
			TRACE(" [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);

			if(strcmp(chFlag, "moov") == 0) {
				check_flag = 1;
				curpos = _ftelli64(fd);
				break;
			}

			_fseeki64(fd, size-8, SEEK_CUR);
		}
		if(check_flag == 0) break;

		//Step2. Get Tracker
		int track_id = 0;	
		check_flag = 0;
		while(!feof(fd)) {
			if(fread(chSize, 1, 4, fd) != 4) break;		//get address
			size = ENDIAN_CONV(chSize);		//convert size			
			if(fread(chFlag, 1, 4, fd) != 4) break;

			pos += size;
			TRACE("         [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);		

			if(strcmp(chFlag, "trak") == 0) {
				curpos = _ftelli64(fd);
				track_id ++;
				if(track_id == 3) {
					check_flag = 1;
					//Step3. Check Tracker
					do {					
						//Step4. Get mdia from trak
						int check_flag2 = 0;
						while(_ftelli64(fd) <= pos) {
							if(fread(chSize, 1, 4, fd) != 4) break;		//get address
							size = ENDIAN_CONV(chSize);		//convert size			
							if(fread(chFlag, 1, 4, fd) != 4) break;

							TRACE("                [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
							if(strcmp(chFlag, "mdia") == 0) {
								check_flag2 = 1;
								break;
							}
							_fseeki64(fd, size-8, SEEK_CUR);
						}
						if(check_flag2 == 0) break;

						//Step5. Get minf from mdia
						check_flag2 = 0;
						while(_ftelli64(fd) <= pos) {
							if(fread(chSize, 1, 4, fd) != 4) break;		//get address
							size = ENDIAN_CONV(chSize);		//convert size			
							if(fread(chFlag, 1, 4, fd) != 4) break;

							TRACE("                        [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
							if(strcmp(chFlag, "minf") == 0) {
								check_flag2 = 1;
								break;
							}
							_fseeki64(fd, size-8, SEEK_CUR);
						}
						if(check_flag2 == 0) break;

						//Step6. Get stbl from minf
						check_flag2 = 0;
						while(_ftelli64(fd) <= pos) {
							if(fread(chSize, 1, 4, fd) != 4) break;		//get address
							size = ENDIAN_CONV(chSize);		//convert size			
							if(fread(chFlag, 1, 4, fd) != 4) break;

							TRACE("                                [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
							if(strcmp(chFlag, "stbl") == 0) {
								check_flag2 = 1;
								break;
							}
							_fseeki64(fd, size-8, SEEK_CUR);
						}
						if(check_flag2 == 0) break;

						//Step7. Get stco from stbl
						check_flag2 = 0;
						while(_ftelli64(fd) <= pos) {
							if(fread(chSize, 1, 4, fd) != 4) break;		//get address
							size = ENDIAN_CONV(chSize);		//convert size			
							if(fread(chFlag, 1, 4, fd) != 4) break;

							TRACE("                                        [0x%08X]%s - Pos:0x%08X\n", *((unsigned int*)chSize), chFlag, pos);
							if(strcmp(chFlag, "stco") == 0) {
								check_flag2 = 1;
								break;
							}
							_fseeki64(fd, size-8, SEEK_CUR);
						}
						if(check_flag2 == 0) break;

						//Step8. Get index from stco
						unsigned int addr = 0;
						unsigned int *alladdr = NULL;
						if(fread(chSize, 1, 4, fd) != 4) break;   //[4]
						if(fread(chSize, 1, 4, fd) != 4) break;   //[4] index size						
						size = ENDIAN_CONV(chSize);	
						if(size > 0) {
							alladdr = (unsigned int *)malloc((size + 1)*sizeof(unsigned int));
						}
						for(i = 0; i < size; i++) {
							unsigned int addr = 0, rval = 0;
							memset(chSize, 0, 8);
							fread(chSize, 1, 4, fd);								
							addr = ENDIAN_CONV(chSize);
							alladdr[i] = addr; //Skip 0x00 0x35
						}
						TRACE(" founded %d indexs!\n", size);
						int found_key = 0;
						int key = 0;
						char cache[20][128] = {0};
						for(i = 0; i < size; i++) {			
							int len;
							
							memset(rbuf, 0, 128);							
							//fseek(fd, alladdr[i], SEEK_SET);
							_fseeki64(fd, alladdr[i], SEEK_SET);
							fread(chSize, 1, 2, fd);				//[Size:2][GPS String:Size]
							len = (chSize[0] << 8) | chSize[1];    
							fread(rbuf, 1, len, fd);
							rbuf[0] = 0x20;
							TRACE("#%d, Addr:0x%08X, len:%d, data:%s", i, alladdr[i], len, rbuf);			
	
							if(found_key == 0) {
								if(len == 11) {
									char num[2] = {0};
									found_key = 1;
									//value = Matrix[0]+Matrix[1]+Matrix[2]+Matrix[3]+Matrix[4]+ Matrix[4]+Matrix[5]
									//        +Matrix[6]+Matrix[7]+Matrix[7];%
#define P(x)  (1+x)
									num[0] = rbuf[P(0)]; key += atoi(num);
									num[0] = rbuf[P(1)]; key += atoi(num);
									num[0] = rbuf[P(2)]; key += atoi(num);
									num[0] = rbuf[P(3)]; key += atoi(num);
									num[0] = rbuf[P(4)]; key += atoi(num);
									num[0] = rbuf[P(4)]; key += atoi(num);
									num[0] = rbuf[P(5)]; key += atoi(num);
									num[0] = rbuf[P(6)]; key += atoi(num);
									num[0] = rbuf[P(7)]; key += atoi(num);
									num[0] = rbuf[P(7)]; key += atoi(num);
									TRACE("    Founded key: %s, %d, 0x%08X,0x%08X,0x%08X,0x%08X,0x%08X,0x%08X,0x%08X,0x%08X\n", rbuf, key,
										rbuf[P(0)],rbuf[P(1)],rbuf[P(2)],rbuf[P(3)],rbuf[P(4)],rbuf[P(5)],rbuf[P(6)],rbuf[P(7)]);
									TRACE("\n");
									
								    int j;
									for(j = 0; j < i; j++) {
										ParseLine(&cache[j][1], key);
									}
								} else {
									if(i < 20) memcpy(cache[i], rbuf, len);
								}
							} else {
								ParseLine(&rbuf[1], key);
							}
						}				
						if(alladdr != NULL) {
							free(alladdr);
							alladdr = NULL;
						}
						break;
					}while(0);

					_fseeki64(fd, curpos, SEEK_SET);
				}				
			}

			if(check_flag == 1) break;
			_fseeki64(fd, size-8, SEEK_CUR);			
		}		
	}while(0);

end:
	fclose(fd);
	fd = NULL;	

	return m_infoList.GetCount();	
}

int CAssistFile::GetNode(int idx, AssistInfo_t &node)
{
	POSITION	pos = m_infoList.FindIndex(idx);

	if(pos) {
		node = m_infoList.GetAt(pos);
		return 0;
	} else {
		node.gps_lat = _T("0");
		node.gps_lgt = _T("0");
		node.gsensor_x = 0;
		node.gsensor_y = 0;
		node.gsensor_z = 0;
		node.spd       = 0;
		return -1;
	}	
}

void CAssistFile::ClearList()
{
	m_infoList.RemoveAll();
}
