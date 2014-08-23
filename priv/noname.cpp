///////////////////////////////////////////////////////////////////////////
// C++ code generated with wxFormBuilder (version Jun  5 2014)
// http://www.wxformbuilder.org/
//
// PLEASE DO "NOT" EDIT THIS FILE!
///////////////////////////////////////////////////////////////////////////

#include "noname.h"

///////////////////////////////////////////////////////////////////////////

MyFrame1::MyFrame1( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style ) : wxFrame( parent, id, title, pos, size, style )
{
	this->SetSizeHints( wxSize( 800,370 ), wxDefaultSize );
	
	m_menubar1 = new wxMenuBar( 0 );
	m_menu1 = new wxMenu();
	wxMenuItem* m_menuItem1;
	m_menuItem1 = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("Load Config") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_menuItem1 );
	
	wxMenuItem* m_menuItem2;
	m_menuItem2 = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("Store Config") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_menuItem2 );
	
	m_menu1->AppendSeparator();
	
	wxMenuItem* m_menuItem3;
	m_menuItem3 = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("Select Log File") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_menuItem3 );
	
	m_menubar1->Append( m_menu1, wxT("File") ); 
	
	m_menu2 = new wxMenu();
	wxMenuItem* m_menuItem4;
	m_menuItem4 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Start Log") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItem4 );
	
	wxMenuItem* m_menuItem5;
	m_menuItem5 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Continue Log") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItem5 );
	
	wxMenuItem* m_menuItem6;
	m_menuItem6 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Stop Log") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItem6 );
	
	m_menu2->AppendSeparator();
	
	wxMenuItem* m_menuItem8;
	m_menuItem8 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("log Hrtbt") ) , wxEmptyString, wxITEM_CHECK );
	m_menu2->Append( m_menuItem8 );
	m_menuItem8->Check( true );
	
	wxMenuItem* m_menuItem9;
	m_menuItem9 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Log fast") ) , wxEmptyString, wxITEM_CHECK );
	m_menu2->Append( m_menuItem9 );
	m_menuItem9->Check( true );
	
	wxMenuItem* m_menuItem10;
	m_menuItem10 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Log safe") ) , wxEmptyString, wxITEM_CHECK );
	m_menu2->Append( m_menuItem10 );
	m_menuItem10->Check( true );
	
	wxMenuItem* m_menuItem11;
	m_menuItem11 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Log mast") ) , wxEmptyString, wxITEM_CHECK );
	m_menu2->Append( m_menuItem11 );
	m_menuItem11->Check( true );
	
	wxMenuItem* m_menuItem12;
	m_menuItem12 = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Log states") ) , wxEmptyString, wxITEM_CHECK );
	m_menu2->Append( m_menuItem12 );
	m_menuItem12->Check( true );
	
	m_menubar1->Append( m_menu2, wxT("Debug") ); 
	
	this->SetMenuBar( m_menubar1 );
	
	m_toolBar1 = this->CreateToolBar( wxTB_HORIZONTAL, wxID_ANY ); 
	m_toolBar1->SetMinSize( wxSize( -1,58 ) );
	
	m_tool1 = m_toolBar1->AddTool( wxID_ANY, wxT("tool"), wxBitmap( wxT("m580.png"), wxBITMAP_TYPE_ANY ), wxNullBitmap, wxITEM_NORMAL, wxEmptyString, wxEmptyString, NULL ); 
	
	m_toolBar1->Realize(); 
	
	m_statusBar1 = this->CreateStatusBar( 1, wxST_SIZEGRIP, wxID_ANY );
	wxBoxSizer* bSizer1;
	bSizer1 = new wxBoxSizer( wxHORIZONTAL );
	
	wxGridSizer* gSizer1;
	gSizer1 = new wxGridSizer( 3, 3, 4, 4 );
	
	gSizer1->SetMinSize( wxSize( 210,210 ) ); 
	m_staticText10 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText10->Wrap( -1 );
	gSizer1->Add( m_staticText10, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText101 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText101->Wrap( -1 );
	gSizer1->Add( m_staticText101, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText102 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText102->Wrap( -1 );
	gSizer1->Add( m_staticText102, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText103 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText103->Wrap( -1 );
	gSizer1->Add( m_staticText103, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText104 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText104->Wrap( -1 );
	gSizer1->Add( m_staticText104, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText105 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText105->Wrap( -1 );
	gSizer1->Add( m_staticText105, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText106 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText106->Wrap( -1 );
	gSizer1->Add( m_staticText106, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText107 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText107->Wrap( -1 );
	gSizer1->Add( m_staticText107, 0, wxALL|wxEXPAND, 5 );
	
	m_staticText108 = new wxStaticText( this, wxID_ANY, wxT("MyLabel"), wxDefaultPosition, wxDefaultSize, 0|wxRAISED_BORDER );
	m_staticText108->Wrap( -1 );
	gSizer1->Add( m_staticText108, 0, wxALL|wxEXPAND, 5 );
	
	
	bSizer1->Add( gSizer1, 0, wxALL, 5 );
	
	wxBoxSizer* bSizer2;
	bSizer2 = new wxBoxSizer( wxVERTICAL );
	
	wxBoxSizer* bSizer31;
	bSizer31 = new wxBoxSizer( wxHORIZONTAL );
	
	m_staticText11 = new wxStaticText( this, wxID_ANY, wxT("time:"), wxDefaultPosition, wxSize( 60,-1 ), wxALIGN_RIGHT );
	m_staticText11->Wrap( -1 );
	m_staticText11->SetBackgroundColour( wxSystemSettings::GetColour( wxSYS_COLOUR_APPWORKSPACE ) );
	
	bSizer31->Add( m_staticText11, 0, wxALIGN_CENTER_VERTICAL|wxALL, 5 );
	
	m_bitmap11 = new wxStaticBitmap( this, wxID_ANY, wxNullBitmap, wxDefaultPosition, wxDefaultSize, 0 );
	m_bitmap11->SetBackgroundColour( wxColour( 224, 224, 224 ) );
	
	bSizer31->Add( m_bitmap11, 1, wxALL|wxEXPAND, 5 );
	
	
	bSizer2->Add( bSizer31, 0, wxEXPAND, 5 );
	
	wxBoxSizer* bSizer32;
	bSizer32 = new wxBoxSizer( wxHORIZONTAL );
	
	m_staticText12 = new wxStaticText( this, wxID_ANY, wxT("hrtbt:"), wxDefaultPosition, wxSize( 60,-1 ), wxALIGN_RIGHT );
	m_staticText12->Wrap( -1 );
	m_staticText12->SetBackgroundColour( wxSystemSettings::GetColour( wxSYS_COLOUR_APPWORKSPACE ) );
	
	bSizer32->Add( m_staticText12, 0, wxALIGN_CENTER_VERTICAL|wxALL, 5 );
	
	m_bitmap12 = new wxStaticBitmap( this, wxID_ANY, wxNullBitmap, wxDefaultPosition, wxDefaultSize, 0 );
	m_bitmap12->SetBackgroundColour( wxColour( 224, 224, 224 ) );
	
	bSizer32->Add( m_bitmap12, 1, wxALL|wxEXPAND, 5 );
	
	
	bSizer2->Add( bSizer32, 1, wxEXPAND, 5 );
	
	wxBoxSizer* bSizer33;
	bSizer33 = new wxBoxSizer( wxHORIZONTAL );
	
	m_staticText13 = new wxStaticText( this, wxID_ANY, wxT("fast:"), wxDefaultPosition, wxSize( 60,-1 ), wxALIGN_RIGHT );
	m_staticText13->Wrap( -1 );
	m_staticText13->SetBackgroundColour( wxSystemSettings::GetColour( wxSYS_COLOUR_APPWORKSPACE ) );
	
	bSizer33->Add( m_staticText13, 0, wxALIGN_CENTER_VERTICAL|wxALL, 5 );
	
	m_bitmap13 = new wxStaticBitmap( this, wxID_ANY, wxNullBitmap, wxDefaultPosition, wxDefaultSize, 0 );
	m_bitmap13->SetBackgroundColour( wxColour( 224, 224, 224 ) );
	
	bSizer33->Add( m_bitmap13, 1, wxALL|wxEXPAND, 5 );
	
	
	bSizer2->Add( bSizer33, 1, wxEXPAND, 5 );
	
	wxBoxSizer* bSizer34;
	bSizer34 = new wxBoxSizer( wxHORIZONTAL );
	
	m_staticText14 = new wxStaticText( this, wxID_ANY, wxT("safe:"), wxDefaultPosition, wxSize( 60,-1 ), wxALIGN_RIGHT );
	m_staticText14->Wrap( -1 );
	m_staticText14->SetBackgroundColour( wxSystemSettings::GetColour( wxSYS_COLOUR_APPWORKSPACE ) );
	
	bSizer34->Add( m_staticText14, 0, wxALIGN_CENTER_VERTICAL|wxALL, 5 );
	
	m_bitmap14 = new wxStaticBitmap( this, wxID_ANY, wxNullBitmap, wxDefaultPosition, wxDefaultSize, 0 );
	m_bitmap14->SetBackgroundColour( wxColour( 224, 224, 224 ) );
	
	bSizer34->Add( m_bitmap14, 1, wxALL|wxEXPAND, 5 );
	
	
	bSizer2->Add( bSizer34, 1, wxEXPAND, 5 );
	
	wxBoxSizer* bSizer3;
	bSizer3 = new wxBoxSizer( wxHORIZONTAL );
	
	m_staticText1 = new wxStaticText( this, wxID_ANY, wxT("mast:"), wxDefaultPosition, wxSize( 60,-1 ), wxALIGN_RIGHT );
	m_staticText1->Wrap( -1 );
	m_staticText1->SetBackgroundColour( wxSystemSettings::GetColour( wxSYS_COLOUR_APPWORKSPACE ) );
	
	bSizer3->Add( m_staticText1, 0, wxALIGN_CENTER_VERTICAL|wxALL, 5 );
	
	m_bitmap1 = new wxStaticBitmap( this, wxID_ANY, wxNullBitmap, wxDefaultPosition, wxDefaultSize, 0 );
	m_bitmap1->SetBackgroundColour( wxColour( 224, 224, 224 ) );
	
	bSizer3->Add( m_bitmap1, 1, wxALL|wxEXPAND, 5 );
	
	
	bSizer2->Add( bSizer3, 1, wxEXPAND, 5 );
	
	
	bSizer1->Add( bSizer2, 1, wxEXPAND, 5 );
	
	
	this->SetSizer( bSizer1 );
	this->Layout();
	bSizer1->Fit( this );
	
	this->Centre( wxBOTH );
}

MyFrame1::~MyFrame1()
{
}
