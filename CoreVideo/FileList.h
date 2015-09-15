#include <string>
#include <vector>
#include <stdio.h>
#pragma once
using namespace std;
typedef struct tagFileNode {
	string	filepath;
	string  filename;
	string  assist_filepath;
	string  file_dt;
	int		duration;
	int     rd_only;
	int     is_sunplus;				//@20121214
	int     is_a7l;					//@20130627
	int		is_novatek;				//@20130819
}FileNode_t, *PFileNode_t;

class CFileList
{
public:
	CFileList(void);
	~CFileList(void);

private:
	vector<FileNode_t>	m_FileList;		//Need #include <afxtempl.h>
		
public:

	void	InitNode(FileNode_t &node);
	
	FileNode_t createNodeInfo(string szFilePath);

	void    CheckPlatform(FileNode_t &node, string szFilePath);		//@20121214
};
