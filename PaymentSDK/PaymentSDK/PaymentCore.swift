//
//  PaymentCore.swift
//  PaymentSDK
//
//  Created by Maxym Krutykh on 21.06.2020.
//  Copyright © 2020 XcooBee. All rights reserved.
//

import UIKit

public class PaymentCore {
    public static let shared = PaymentCore()
    
    private var config: XcooBeePayConfig?
    
    private let appUrl = "https://app.xcoobee.com"
    
    private let logoSrc =
    "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KPHN2ZyB2ZXJzaW9uPSIxLjIiIHdpZHRoPSI5NC4yM21tIiBoZWlnaHQ9IjkzLjk4bW0iIHZpZXdCb3g9IjAgMCA5NDIzIDkzOTgiIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaWRZTWlkIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIHN0cm9rZS13aWR0aD0iMjguMjIyIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOm9vbz0iaHR0cDovL3htbC5vcGVub2ZmaWNlLm9yZy9zdmcvZXhwb3J0IiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeG1sbnM6cHJlc2VudGF0aW9uPSJodHRwOi8vc3VuLmNvbS94bWxucy9zdGFyb2ZmaWNlL3ByZXNlbnRhdGlvbiIgeG1sbnM6c21pbD0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9TTUlMMjAvIiB4bWxuczphbmltPSJ1cm46b2FzaXM6bmFtZXM6dGM6b3BlbmRvY3VtZW50OnhtbG5zOmFuaW1hdGlvbjoxLjAiIHhtbDpzcGFjZT0icHJlc2VydmUiPgogPGRlZnMgY2xhc3M9IkNsaXBQYXRoR3JvdXAiPgogIDxjbGlwUGF0aCBpZD0icHJlc2VudGF0aW9uX2NsaXBfcGF0aCIgY2xpcFBhdGhVbml0cz0idXNlclNwYWNlT25Vc2UiPgogICA8cmVjdCB4PSIwIiB5PSIwIiB3aWR0aD0iOTQyMyIgaGVpZ2h0PSI5Mzk4Ii8+CiAgPC9jbGlwUGF0aD4KICA8Y2xpcFBhdGggaWQ9InByZXNlbnRhdGlvbl9jbGlwX3BhdGhfc2hyaW5rIiBjbGlwUGF0aFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CiAgIDxyZWN0IHg9IjkiIHk9IjkiIHdpZHRoPSI5NDA1IiBoZWlnaHQ9IjkzODAiLz4KICA8L2NsaXBQYXRoPgogPC9kZWZzPgogPGRlZnMgY2xhc3M9IlRleHRTaGFwZUluZGV4Ij4KICA8ZyBvb286c2xpZGU9ImlkMSIgb29vOmlkLWxpc3Q9ImlkMyBpZDQgaWQ1IGlkNiBpZDcgaWQ4IGlkOSBpZDEwIGlkMTEgaWQxMiBpZDEzIi8+CiA8L2RlZnM+CiA8ZGVmcyBjbGFzcz0iRW1iZWRkZWRCdWxsZXRDaGFycyI+CiAgPGcgaWQ9ImJ1bGxldC1jaGFyLXRlbXBsYXRlLTU3MzU2IiB0cmFuc2Zvcm09InNjYWxlKDAuMDAwNDg4MjgxMjUsLTAuMDAwNDg4MjgxMjUpIj4KICAgPHBhdGggZD0iTSA1ODAsMTE0MSBMIDExNjMsNTcxIDU4MCwwIC00LDU3MSA1ODAsMTE0MSBaIi8+CiAgPC9nPgogIDxnIGlkPSJidWxsZXQtY2hhci10ZW1wbGF0ZS01NzM1NCIgdHJhbnNmb3JtPSJzY2FsZSgwLjAwMDQ4ODI4MTI1LC0wLjAwMDQ4ODI4MTI1KSI+CiAgIDxwYXRoIGQ9Ik0gOCwxMTI4IEwgMTEzNywxMTI4IDExMzcsMCA4LDAgOCwxMTI4IFoiLz4KICA8L2c+CiAgPGcgaWQ9ImJ1bGxldC1jaGFyLXRlbXBsYXRlLTEwMTQ2IiB0cmFuc2Zvcm09InNjYWxlKDAuMDAwNDg4MjgxMjUsLTAuMDAwNDg4MjgxMjUpIj4KICAgPHBhdGggZD0iTSAxNzQsMCBMIDYwMiw3MzkgMTc0LDE0ODEgMTQ1Niw3MzkgMTc0LDAgWiBNIDEzNTgsNzM5IEwgMzA5LDEzNDYgNjU5LDczOSAxMzU4LDczOSBaIi8+CiAgPC9nPgogIDxnIGlkPSJidWxsZXQtY2hhci10ZW1wbGF0ZS0xMDEzMiIgdHJhbnNmb3JtPSJzY2FsZSgwLjAwMDQ4ODI4MTI1LC0wLjAwMDQ4ODI4MTI1KSI+CiAgIDxwYXRoIGQ9Ik0gMjAxNSw3MzkgTCAxMjc2LDAgNzE3LDAgMTI2MCw1NDMgMTc0LDU0MyAxNzQsOTM2IDEyNjAsOTM2IDcxNywxNDgxIDEyNzQsMTQ4MSAyMDE1LDczOSBaIi8+CiAgPC9nPgogIDxnIGlkPSJidWxsZXQtY2hhci10ZW1wbGF0ZS0xMDAwNyIgdHJhbnNmb3JtPSJzY2FsZSgwLjAwMDQ4ODI4MTI1LC0wLjAwMDQ4ODI4MTI1KSI+CiAgIDxwYXRoIGQ9Ik0gMCwtMiBDIC03LDE0IC0xNiwyNyAtMjUsMzcgTCAzNTYsNTY3IEMgMjYyLDgyMyAyMTUsOTUyIDIxNSw5NTQgMjE1LDk3OSAyMjgsOTkyIDI1NSw5OTIgMjY0LDk5MiAyNzYsOTkwIDI4OSw5ODcgMzEwLDk5MSAzMzEsOTk5IDM1NCwxMDEyIEwgMzgxLDk5OSA0OTIsNzQ4IDc3MiwxMDQ5IDgzNiwxMDI0IDg2MCwxMDQ5IEMgODgxLDEwMzkgOTAxLDEwMjUgOTIyLDEwMDYgODg2LDkzNyA4MzUsODYzIDc3MCw3ODQgNzY5LDc4MyA3MTAsNzE2IDU5NCw1ODQgTCA3NzQsMjIzIEMgNzc0LDE5NiA3NTMsMTY4IDcxMSwxMzkgTCA3MjcsMTE5IEMgNzE3LDkwIDY5OSw3NiA2NzIsNzYgNjQxLDc2IDU3MCwxNzggNDU3LDM4MSBMIDE2NCwtNzYgQyAxNDIsLTExMCAxMTEsLTEyNyA3MiwtMTI3IDMwLC0xMjcgOSwtMTEwIDgsLTc2IDEsLTY3IC0yLC01MiAtMiwtMzIgLTIsLTIzIC0xLC0xMyAwLC0yIFoiLz4KICA8L2c+CiAgPGcgaWQ9ImJ1bGxldC1jaGFyLXRlbXBsYXRlLTEwMDA0IiB0cmFuc2Zvcm09InNjYWxlKDAuMDAwNDg4MjgxMjUsLTAuMDAwNDg4MjgxMjUpIj4KICAgPHBhdGggZD0iTSAyODUsLTMzIEMgMTgyLC0zMyAxMTEsMzAgNzQsMTU2IDUyLDIyOCA0MSwzMzMgNDEsNDcxIDQxLDU0OSA1NSw2MTYgODIsNjcyIDExNiw3NDMgMTY5LDc3OCAyNDAsNzc4IDI5Myw3NzggMzI4LDc0NyAzNDYsNjg0IEwgMzY5LDUwOCBDIDM3Nyw0NDQgMzk3LDQxMSA0MjgsNDEwIEwgMTE2MywxMTE2IEMgMTE3NCwxMTI3IDExOTYsMTEzMyAxMjI5LDExMzMgMTI3MSwxMTMzIDEyOTIsMTExOCAxMjkyLDEwODcgTCAxMjkyLDk2NSBDIDEyOTIsOTI5IDEyODIsOTAxIDEyNjIsODgxIEwgNDQyLDQ3IEMgMzkwLC02IDMzOCwtMzMgMjg1LC0zMyBaIi8+CiAgPC9nPgogIDxnIGlkPSJidWxsZXQtY2hhci10ZW1wbGF0ZS05Njc5IiB0cmFuc2Zvcm09InNjYWxlKDAuMDAwNDg4MjgxMjUsLTAuMDAwNDg4MjgxMjUpIj4KICAgPHBhdGggZD0iTSA4MTMsMCBDIDYzMiwwIDQ4OSw1NCAzODMsMTYxIDI3NiwyNjggMjIzLDQxMSAyMjMsNTkyIDIyMyw3NzMgMjc2LDkxNiAzODMsMTAyMyA0ODksMTEzMCA2MzIsMTE4NCA4MTMsMTE4NCA5OTIsMTE4NCAxMTM2LDExMzAgMTI0NSwxMDIzIDEzNTMsOTE2IDE0MDcsNzcyIDE0MDcsNTkyIDE0MDcsNDEyIDEzNTMsMjY4IDEyNDUsMTYxIDExMzYsNTQgOTkyLDAgODEzLDAgWiIvPgogIDwvZz4KICA8ZyBpZD0iYnVsbGV0LWNoYXItdGVtcGxhdGUtODIyNiIgdHJhbnNmb3JtPSJzY2FsZSgwLjAwMDQ4ODI4MTI1LC0wLjAwMDQ4ODI4MTI1KSI+CiAgIDxwYXRoIGQ9Ik0gMzQ2LDQ1NyBDIDI3Myw0NTcgMjA5LDQ4MyAxNTUsNTM1IDEwMSw1ODYgNzQsNjQ5IDc0LDcyMyA3NCw3OTYgMTAxLDg1OSAxNTUsOTExIDIwOSw5NjMgMjczLDk4OSAzNDYsOTg5IDQxOSw5ODkgNDgwLDk2MyA1MzEsOTEwIDU4Miw4NTkgNjA4LDc5NiA2MDgsNzIzIDYwOCw2NDggNTgzLDU4NiA1MzIsNTM1IDQ4Miw0ODMgNDIwLDQ1NyAzNDYsNDU3IFoiLz4KICA8L2c+CiAgPGcgaWQ9ImJ1bGxldC1jaGFyLXRlbXBsYXRlLTgyMTEiIHRyYW5zZm9ybT0ic2NhbGUoMC4wMDA0ODgyODEyNSwtMC4wMDA0ODgyODEyNSkiPgogICA8cGF0aCBkPSJNIC00LDQ1OSBMIDExMzUsNDU5IDExMzUsNjA2IC00LDYwNiAtNCw0NTkgWiIvPgogIDwvZz4KICA8ZyBpZD0iYnVsbGV0LWNoYXItdGVtcGxhdGUtNjE1NDgiIHRyYW5zZm9ybT0ic2NhbGUoMC4wMDA0ODgyODEyNSwtMC4wMDA0ODgyODEyNSkiPgogICA8cGF0aCBkPSJNIDE3Myw3NDAgQyAxNzMsOTAzIDIzMSwxMDQzIDM0NiwxMTU5IDQ2MiwxMjc0IDYwMSwxMzMyIDc2NSwxMzMyIDkyOCwxMzMyIDEwNjcsMTI3NCAxMTgzLDExNTkgMTI5OSwxMDQzIDEzNTcsOTAzIDEzNTcsNzQwIDEzNTcsNTc3IDEyOTksNDM3IDExODMsMzIyIDEwNjcsMjA2IDkyOCwxNDggNzY1LDE0OCA2MDEsMTQ4IDQ2MiwyMDYgMzQ2LDMyMiAyMzEsNDM3IDE3Myw1NzcgMTczLDc0MCBaIi8+CiAgPC9nPgogPC9kZWZzPgogPGRlZnMgY2xhc3M9IlRleHRFbWJlZGRlZEJpdG1hcHMiLz4KIDxnPgogIDxnIGlkPSJpZDIiIGNsYXNzPSJNYXN0ZXJfU2xpZGUiPgogICA8ZyBpZD0iYmctaWQyIiBjbGFzcz0iQmFja2dyb3VuZCIvPgogICA8ZyBpZD0iYm8taWQyIiBjbGFzcz0iQmFja2dyb3VuZE9iamVjdHMiLz4KICA8L2c+CiA8L2c+CiA8ZyBjbGFzcz0iU2xpZGVHcm91cCI+CiAgPGc+CiAgIDxnIGlkPSJjb250YWluZXItaWQxIj4KICAgIDxnIGlkPSJpZDEiIGNsYXNzPSJTbGlkZSIgY2xpcC1wYXRoPSJ1cmwoI3ByZXNlbnRhdGlvbl9jbGlwX3BhdGgpIj4KICAgICA8ZyBjbGFzcz0iUGFnZSI+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DdXN0b21TaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQzIj4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iLTEiIHk9Ii0yIiB3aWR0aD0iOTQyNSIgaGVpZ2h0PSI5NDAxIi8+CiAgICAgICAgPHBhdGggZmlsbD0icmdiKDE4NiwxODYsMTg2KSIgc3Ryb2tlPSJub25lIiBkPSJNIDQ3MTEsLTEgQyA1NTc4LC0xIDYzMTUsMTk2IDcwNjcsNjI5IDc4MTgsMTA2MSA4MzU3LDE1OTkgODc5MSwyMzQ4IDkyMjQsMzA5OCA5NDIyLDM4MzMgOTQyMiw0Njk4IDk0MjIsNTU2MyA5MjI0LDYyOTggODc5MSw3MDQ3IDgzNTcsNzc5NyA3ODE4LDgzMzUgNzA2Nyw4NzY3IDYzMTUsOTIwMCA1NTc4LDkzOTcgNDcxMSw5Mzk3IDM4NDQsOTM5NyAzMTA3LDkyMDAgMjM1Niw4NzY3IDE2MDQsODMzNSAxMDY1LDc3OTcgNjMxLDcwNDggMTk4LDYyOTggMCw1NTYzIDAsNDY5OCAwLDM4MzMgMTk4LDMwOTggNjMxLDIzNDkgMTA2NSwxNTk5IDE2MDQsMTA2MSAyMzU1LDYyOSAzMTA3LDE5NiAzODQ0LC0xIDQ3MTEsLTEgTCA0NzExLC0xIFoiLz4KICAgICAgICA8cGF0aCBmaWxsPSJub25lIiBzdHJva2U9InJnYigyNTUsMjU1LDI1NSkiIGQ9Ik0gNDcxMSwtMSBDIDU1NzgsLTEgNjMxNSwxOTYgNzA2Nyw2MjkgNzgxOCwxMDYxIDgzNTcsMTU5OSA4NzkxLDIzNDggOTIyNCwzMDk4IDk0MjIsMzgzMyA5NDIyLDQ2OTggOTQyMiw1NTYzIDkyMjQsNjI5OCA4NzkxLDcwNDcgODM1Nyw3Nzk3IDc4MTgsODMzNSA3MDY3LDg3NjcgNjMxNSw5MjAwIDU1NzgsOTM5NyA0NzExLDkzOTcgMzg0NCw5Mzk3IDMxMDcsOTIwMCAyMzU2LDg3NjcgMTYwNCw4MzM1IDEwNjUsNzc5NyA2MzEsNzA0OCAxOTgsNjI5OCAwLDU1NjMgMCw0Njk4IDAsMzgzMyAxOTgsMzA5OCA2MzEsMjM0OSAxMDY1LDE1OTkgMTYwNCwxMDYxIDIzNTUsNjI5IDMxMDcsMTk2IDM4NDQsLTEgNDcxMSwtMSBMIDQ3MTEsLTEgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DbG9zZWRCZXppZXJTaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQ0Ij4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iMjkxNiIgeT0iNDA0MSIgd2lkdGg9IjM1OTMiIGhlaWdodD0iNTk5Ii8+CiAgICAgICAgPHBhdGggZmlsbD0icmdiKDI1NSwxODEsMTcpIiBzdHJva2U9Im5vbmUiIGQ9Ik0gNjI4Nyw0MDQyIEwgMzEzNyw0MDQyIEMgMzAxNSw0MDQyIDI5MTcsNDE0MSAyOTE3LDQyNjAgTCAyOTE3LDQ2MzkgNjUwNyw0NjM5IDY1MDcsNDI2MCBDIDY1MDcsNDE0MSA2NDA4LDQwNDIgNjI4Nyw0MDQyIFoiLz4KICAgICAgIDwvZz4KICAgICAgPC9nPgogICAgICA8ZyBjbGFzcz0iY29tLnN1bi5zdGFyLmRyYXdpbmcuUG9seVBvbHlnb25TaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQ1Ij4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iMjkxNiIgeT0iNTk2NCIgd2lkdGg9IjM1OTMiIGhlaWdodD0iNTk4Ii8+CiAgICAgICAgPHBhdGggZmlsbD0icmdiKDI1NSwxODEsMTcpIiBzdHJva2U9Im5vbmUiIGQ9Ik0gMjkxNyw1OTY0IEwgNjUwNyw1OTY0IDY1MDcsNjU2MSAyOTE3LDY1NjEgMjkxNyw1OTY0IFoiLz4KICAgICAgIDwvZz4KICAgICAgPC9nPgogICAgICA8ZyBjbGFzcz0iY29tLnN1bi5zdGFyLmRyYXdpbmcuQ2xvc2VkQmV6aWVyU2hhcGUiPgogICAgICAgPGcgaWQ9ImlkNiI+CiAgICAgICAgPHJlY3QgY2xhc3M9IkJvdW5kaW5nQm94IiBzdHJva2U9Im5vbmUiIGZpbGw9Im5vbmUiIHg9IjMwODAiIHk9IjY5MjUiIHdpZHRoPSIzMjYzIiBoZWlnaHQ9Ijg3OSIvPgogICAgICAgIDxwYXRoIGZpbGw9InJnYigyNTUsMTgxLDE3KSIgc3Ryb2tlPSJub25lIiBkPSJNIDQ3MTEsNzgwMiBDIDU2OTcsNzgwMiA2MzQyLDY5MjUgNjM0Miw2OTI1IEwgMzA4MSw2OTI1IEMgMzA4MSw2OTI1IDM3MjUsNzgwMiA0NzExLDc4MDIgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DbG9zZWRCZXppZXJTaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQ3Ij4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iNDM0NiIgeT0iODA1MCIgd2lkdGg9IjczMyIgaGVpZ2h0PSI2NzUiLz4KICAgICAgICA8cGF0aCBmaWxsPSJyZ2IoMjU1LDI1NSwyNTUpIiBzdHJva2U9Im5vbmUiIGQ9Ik0gNDM0Nyw4MDUwIEMgNDM0Nyw4MDUwIDQ1MjgsODcyNCA0NzEyLDg3MjQgNDg5NSw4NzI0IDUwNzcsODA1MCA1MDc3LDgwNTAgNDk2MSw4MDcxIDQ4MzksODA4NCA0NzEyLDgwODQgNDU4NSw4MDg0IDQ0NjMsODA3MSA0MzQ3LDgwNTAgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5Qb2x5UG9seWdvblNoYXBlIj4KICAgICAgIDxnIGlkPSJpZDgiPgogICAgICAgIDxyZWN0IGNsYXNzPSJCb3VuZGluZ0JveCIgc3Ryb2tlPSJub25lIiBmaWxsPSJub25lIiB4PSIyOTE2IiB5PSI1MDAyIiB3aWR0aD0iMzU5MyIgaGVpZ2h0PSI1OTkiLz4KICAgICAgICA8cGF0aCBmaWxsPSJyZ2IoMjU1LDE4MSwxNykiIHN0cm9rZT0ibm9uZSIgZD0iTSAyOTE3LDUwMDMgTCA2NTA3LDUwMDMgNjUwNyw1NjAwIDI5MTcsNTYwMCAyOTE3LDUwMDMgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DbG9zZWRCZXppZXJTaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQ5Ij4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iMzI4MiIgeT0iMjI1MyIgd2lkdGg9IjI4NjAiIGhlaWdodD0iMTQyNyIvPgogICAgICAgIDxwYXRoIGZpbGw9InJnYigyNTUsMTgxLDE3KSIgc3Ryb2tlPSJub25lIiBkPSJNIDMyODMsMzY3OCBMIDM2NDksMzY3OCBDIDM2NDksMzA5NCA0MTI2LDI2MTggNDcxMiwyNjE4IDUyOTcsMjYxOCA1Nzc0LDMwOTQgNTc3NCwzNjc4IEwgNjE0MCwzNjc4IEMgNjE0MCwyODkxIDU1MDEsMjI1NCA0NzEyLDIyNTQgMzkyMiwyMjU0IDMyODMsMjg5MSAzMjgzLDM2NzggWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DbG9zZWRCZXppZXJTaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQxMCI+CiAgICAgICAgPHJlY3QgY2xhc3M9IkJvdW5kaW5nQm94IiBzdHJva2U9Im5vbmUiIGZpbGw9Im5vbmUiIHg9IjI3ODgiIHk9IjYxMiIgd2lkdGg9IjE2NjEiIGhlaWdodD0iMTM5NyIvPgogICAgICAgIDxwYXRoIGZpbGw9InJnYigyNTUsMjU1LDI1NSkiIHN0cm9rZT0ibm9uZSIgZD0iTSAzNzU2LDE2MzUgQyAzODc2LDE3NjMgMzk4MiwxODg5IDQwNjksMjAwOCA0MTkwLDE5NjEgNDMxNywxOTI3IDQ0NDgsMTkwOSA0Mjk5LDE2ODkgNDEyMywxNDg4IDM5ODksMTM0OCAzOTE3LDEyNzIgMzI3NSw2MTIgMjk3MSw2MTIgMjg3MSw2MTIgMjc4OSw2OTQgMjc4OSw3OTQgMjc4OSw4OTIgMjg2NCw5NzEgMjk2MCw5NzcgMzA0OSwxMDAyIDMzODMsMTIzNyAzNzU2LDE2MzUgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgIDxnIGNsYXNzPSJjb20uc3VuLnN0YXIuZHJhd2luZy5DbG9zZWRCZXppZXJTaGFwZSI+CiAgICAgICA8ZyBpZD0iaWQxMSI+CiAgICAgICAgPHJlY3QgY2xhc3M9IkJvdW5kaW5nQm94IiBzdHJva2U9Im5vbmUiIGZpbGw9Im5vbmUiIHg9IjQ5NzUiIHk9IjYxMiIgd2lkdGg9IjE2NjEiIGhlaWdodD0iMTM5NyIvPgogICAgICAgIDxwYXRoIGZpbGw9InJnYigyNTUsMjU1LDI1NSkiIHN0cm9rZT0ibm9uZSIgZD0iTSA2NDUxLDYxMiBDIDYxNDcsNjEyIDU1MDcsMTI3MiA1NDM1LDEzNDggNTMwMiwxNDg4IDUxMjMsMTY4OSA0OTc2LDE5MDkgNTEwNiwxOTI3IDUyMzMsMTk2MSA1MzU0LDIwMDggNTQ0MSwxODg5IDU1NDcsMTc2MyA1NjY3LDE2MzUgNjA0MCwxMjM3IDYzNzQsMTAwMiA2NDYyLDk3NSA2NTU4LDk3MSA2NjM0LDg5MiA2NjM0LDc5NCA2NjM0LDY5NCA2NTUzLDYxMiA2NDUxLDYxMiBaIi8+CiAgICAgICA8L2c+CiAgICAgIDwvZz4KICAgICAgPGcgY2xhc3M9ImNvbS5zdW4uc3Rhci5kcmF3aW5nLkNsb3NlZEJlemllclNoYXBlIj4KICAgICAgIDxnIGlkPSJpZDEyIj4KICAgICAgICA8cmVjdCBjbGFzcz0iQm91bmRpbmdCb3giIHN0cm9rZT0ibm9uZSIgZmlsbD0ibm9uZSIgeD0iNTY0IiB5PSI0MzMzIiB3aWR0aD0iMTk4OSIgaGVpZ2h0PSIzMjg4Ii8+CiAgICAgICAgPHBhdGggZmlsbD0icmdiKDI1NSwyNTUsMjU1KSIgc3Ryb2tlPSJub25lIiBkPSJNIDkwMyw3MjkxIEMgMTgxOCw4MjA0IDI1NTEsNjkyNSAyNTUxLDY5MjUgTCAyNTUxLDQzMzQgQyAyNTUxLDQzMzQgLTQxNyw1OTc4IDkwMyw3MjkxIFoiLz4KICAgICAgIDwvZz4KICAgICAgPC9nPgogICAgICA8ZyBjbGFzcz0iY29tLnN1bi5zdGFyLmRyYXdpbmcuQ2xvc2VkQmV6aWVyU2hhcGUiPgogICAgICAgPGcgaWQ9ImlkMTMiPgogICAgICAgIDxyZWN0IGNsYXNzPSJCb3VuZGluZ0JveCIgc3Ryb2tlPSJub25lIiBmaWxsPSJub25lIiB4PSI2ODcyIiB5PSI0MzMzIiB3aWR0aD0iMTk4OSIgaGVpZ2h0PSIzMjg4Ii8+CiAgICAgICAgPHBhdGggZmlsbD0icmdiKDI1NSwyNTUsMjU1KSIgc3Ryb2tlPSJub25lIiBkPSJNIDY4NzIsNDMzNCBMIDY4NzIsNjkyNSBDIDY4NzIsNjkyNSA3NjA1LDgyMDQgODUyMSw3MjkxIDg3NTQsNzA1OSA4ODUzLDY4MTggODg1OSw2NTc2IEwgODg1OSw2NTczIEMgODg4MSw1NDQ3IDY4NzIsNDMzNCA2ODcyLDQzMzQgWiIvPgogICAgICAgPC9nPgogICAgICA8L2c+CiAgICAgPC9nPgogICAgPC9nPgogICA8L2c+CiAgPC9nPgogPC9nPgo8L3N2Zz4="
    
    private init() {}
    
    public func setSystemConfig(_ config: XcooBeePayConfig) {
        self.config = config
    }
    
    public func clearSystemConfig() {
        self.config = nil
    }
    
    // MARK: Create simple payment request
    
    public func createPayUrl (input: InputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createPayQR(input: InputModel, size: Int) -> UIImage? {
        let urlString =  createPayUrl(input: input)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    // MARK: Create payment request with tip
    
    public func createPayUrlwithTip(input: InputModel) -> URL? {
        let securepayItem = SecurePayItem(amount: input.amount, reference: input.reference, tax: input.tax, tip: true)
        let securePay = makeSecurePayItemTotal(securepayItem)
        let string = makePayUrl(securePay: securePay, forcedConfig: input.config)
        return URL(string: string)
    }
    
    public func createPayQRwithTip(input: InputModel, size: Int) -> UIImage? {
        let urlString =  createPayUrlwithTip(input: input)?.absoluteString ?? ""
        return generateQRCode(from: urlString, size: size)
    }
    
    // MARK: eCommerce Method
    
    func createSingleItemUrl(input: InputModel) -> URL? {
        return nil
    }
    
    func createSingleItemQR(input: InputModel, size: Int) -> UIImage? {
        return nil
    }
    
    func createSingleSelectUrl(input: InputModel, items: [String]) -> URL? {
        return nil
    }
    
    func createSingleSelectWithCostUrl(input: InputModel, items: [(String, Double)]) -> URL? {
        return nil
    }
    
    func createMultiSelectUrl(input: InputModel, items: [String]) -> URL? {
        return nil
    }
    
    func createMultiSelectQR(input: InputModel, items: [String], size: Int) -> UIImage? {
        return nil
    }
    
    func createMultiSelectUrlWithCost(input: InputModel, items: [(String, Double)]) -> URL? {
        return nil
    }
    
    func createMultiSelctQRWithCost(input: InputModel, items: [(String, Int)], size: Int) -> UIImage? {
        return nil
    }
    
    func createExternalReferenceURL(priceCode: String) -> URL? {
        return nil
    }
    
    func createExternalReferenceQR(priceCode: String, size: Int) -> UIImage? {
        return nil
    }
    
    private func generateQRCode(from string: String, size: Int?) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let scaleValue = scaleSize(value: filter.outputImage?.extent.height, size: size)
            let transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
            let logoImage = UIImage(named: "xcoobee-logo")
            if let output = filter.outputImage?.transformed(by: transform), let logo = logoImage.flatMap({CIImage(image: $0)}) {
                let image = output.combined(with: logo)
                return image.map { UIImage(ciImage: $0) }
            }
        }
        
        return nil
    }
    
    private func scaleSize(value: CGFloat?, size: Int?) -> CGFloat {
        let imageSize = CGFloat(size ?? 150)
        let scale = imageSize / (value ?? 0)
        return scale
    }
    
    
    private func  makePayUrl(securePay: [SecurePay], forcedConfig: XcooBeePayConfig?) -> String {
        
        guard let config = forcedConfig ?? self.config else { return "" }

      let  dataBase64 = convertToBase64(securePay: securePay)

//      const externalDeviceId = (config!.deviceId || '').substring(0, MAX_DEVICE_ID_LENGTH);
//      const xcoobeeDeviceId = (config!.XcooBeeDeviceId || '').substring(0, MAX_DEVICE_ID_LENGTH);
//      const source = (config!.source || '').substring(0, MAX_SOURCE_LENGTH);
//
//      const deviceId = !!config!.XcooBeeDeviceId ? {
//        [SecurePayParams.XcooBeeDeviceId]: xcoobeeDeviceId || undefined
//      } : {
//        [SecurePayParams.ExternalDeviceId]: externalDeviceId || undefined
//      };
//
//      if (dataBase64.length > MAX_DATA_LENGTH) {
//        console.warn('Data parameter encoded to Base64 is bigger than', MAX_DATA_LENGTH);
//      }
//
//      if ((deviceId[SecurePayParams.XcooBeeDeviceId] || '').length > MAX_DEVICE_ID_LENGTH) {
//        console.warn('XcooBeeDeviceId parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      if ((deviceId[SecurePayParams.ExternalDeviceId] || '').length > MAX_DEVICE_ID_LENGTH) {
//        console.warn('ExternalDeviceId parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      if ((source || '').length > MAX_SOURCE_LENGTH) {
//        console.warn('Source parameter is bigger than', MAX_DEVICE_ID_LENGTH);
//      }
//
//      return QueryString.stringifyUrl({
//        url: `${WEB_SITE_URL}/securePay/${config!.campaignId}/${config!.formId}`,
//        query: {
//          [SecurePayParams.Data]: dataBase64.substring(0, MAX_DATA_LENGTH),
//          [SecurePayParams.Source]: source || undefined,
//          ...deviceId,
//        }
//      });
        let deviceQuery = config.xcoobeeDeviceId != nil ? [SecurePayParams.xcooBeeDeviceId.rawValue: config.xcoobeeDeviceId] :
            [SecurePayParams.externalDeviceId.rawValue: config.deviceId]
        var query = [
            SecurePayParams.data.rawValue: dataBase64,
            SecurePayParams.source.rawValue: config.source,
        ]
        for (key, value) in deviceQuery {
            query[key] = value
        }
        
        let queryString = query.compactMapValues{ $0 }.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        let url = "\(appUrl)/securePay/\(config.campaignId)\(config.formId.map{ "/\($0)" } ?? "")/\(queryString)"
        return url
    }
    
    private func convertToBase64(securePay: [SecurePay]) -> String? {
        let json = securePay.map { $0.toJSON() }
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        let base64Encoded = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        print("Encoded: \(base64Encoded)")

        if let base64Decoded = Data(base64Encoded: base64Encoded, options: Data.Base64DecodingOptions(rawValue: 0))
            .map({ String(data: $0, encoding: .utf8) }) {
            // Convert back to a string
            print("Decoded: \(base64Decoded ?? "")")
        }
        
        return base64Encoded
        
    }
    
    private func checkConfig(config: XcooBeePayConfig?) -> Bool {
//      if (!config) {
//        throw new Error('Instance is not configured, invoke setConfig() before using functions.');
//      }
//
//      if (!config.campaignId) {
//        throw new Error('Campaign id is not configured. Invoke setConfig() before using functions.');
//      } else if (!config.campaignId.match(REGEXP_CAMPAIGN_ID)) {
//        console.warn('Campaign id has incorrect format.');
//      }
//
//      if (!config.formId) {
//        throw new Error('Form id is not configured. Invoke setConfig() before using functions.');
//      } else if (!config.campaignId.match(REGEXP_FORM_ID)) {
//        console.warn('Form id has incorrect format.');
//      }

      return true;
    }
    
    private func makeSecurePayItemTotal(_ securePayItem: SecurePayItem) -> [SecurePay] {
        let payload = SecurePay(amount: securePayItem.amount,
                                tax: securePayItem.tax,
                                reference: securePayItem.reference,
                                logic: [SecurePayLogic(action: .setTotal)])

        return securePayItem.tip ?
            [
                payload,
                SecurePay(reference: "Tip", logic: [SecurePayLogic(action: .setTip)])
            ] : [
                payload
        ];
    }
}


extension CIImage {

    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        let newSize = self.extent.height * 0.1
        let oldSize = image.extent.height
        let scale = newSize / oldSize
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let image = image.transformed(by: transform, highQualityDownsample: true)
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2),
                                                y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage
    }
}
