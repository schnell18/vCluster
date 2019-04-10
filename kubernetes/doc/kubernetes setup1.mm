<map version="freeplane 1.7.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="kubernetes setup" FOLDED="false" ID="ID_213899062" CREATED="1554682632895" MODIFIED="1554682646864" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="3" RULE="ON_BRANCH_CREATION"/>
<node TEXT="common" POSITION="right" ID="ID_1285706594" CREATED="1554682649838" MODIFIED="1554682682325">
<edge COLOR="#ff0000"/>
<node TEXT="mirror setup" ID="ID_77627581" CREATED="1554682698627" MODIFIED="1554682716352"/>
<node TEXT="proxy setup" ID="ID_1612284839" CREATED="1554682716960" MODIFIED="1554682722174"/>
<node TEXT="enable ip forward" ID="ID_425468193" CREATED="1554682723290" MODIFIED="1554682752575"/>
<node TEXT="disable swap" ID="ID_1166558810" CREATED="1554682753205" MODIFIED="1554682761354"/>
<node TEXT="time sync setup" ID="ID_1818466360" CREATED="1554682761776" MODIFIED="1554682779234"/>
<node TEXT="generate certificates" ID="ID_557915682" CREATED="1554682858021" MODIFIED="1554682865843">
<node TEXT="init ca certificates" ID="ID_815902254" CREATED="1554682867213" MODIFIED="1554682884865"/>
<node TEXT="api server" ID="ID_921650668" CREATED="1554682885425" MODIFIED="1554682906607"/>
<node TEXT="scheduler" ID="ID_1931495451" CREATED="1554682907006" MODIFIED="1554682927648"/>
<node TEXT="controller manager" ID="ID_370153192" CREATED="1554682946295" MODIFIED="1554682953953"/>
<node TEXT="service account" ID="ID_1617260444" CREATED="1554682968725" MODIFIED="1554682971653"/>
<node TEXT="admin account" ID="ID_146112295" CREATED="1554682971982" MODIFIED="1554682975031"/>
<node TEXT="each slave node" ID="ID_951974574" CREATED="1554683028653" MODIFIED="1554683086709"/>
<node TEXT="kube-proxy" ID="ID_732434227" CREATED="1554683115641" MODIFIED="1554683121485"/>
</node>
<node TEXT="generate kubeconfig" ID="ID_1151363978" CREATED="1554683240502" MODIFIED="1554683253065"/>
</node>
<node TEXT="slave" POSITION="left" ID="ID_1834404858" CREATED="1554682692400" MODIFIED="1554682694691">
<edge COLOR="#00ff00"/>
<node TEXT="download slave binaries" ID="ID_1635428691" CREATED="1554683363672" MODIFIED="1554683372554"/>
<node TEXT="install slave binaries" ID="ID_549693777" CREATED="1554683373970" MODIFIED="1554683378985"/>
<node TEXT="config daemons" ID="ID_1660049971" CREATED="1554683439994" MODIFIED="1554683559251">
<node TEXT="kubelet" ID="ID_978675702" CREATED="1554683455267" MODIFIED="1554683459192"/>
<node TEXT="kube-proxy" ID="ID_1695100549" CREATED="1554683459892" MODIFIED="1554683464757"/>
<node TEXT="containerd" ID="ID_1032027732" CREATED="1554683465734" MODIFIED="1554683469406"/>
</node>
<node TEXT="start containerd, kubelet, kube-proxy" ID="ID_4635864" CREATED="1554683472324" MODIFIED="1554683576120"/>
<node TEXT="pull k8s.gcr.io meta image" ID="ID_828836589" CREATED="1554683385784" MODIFIED="1554683430148"/>
</node>
<node TEXT="master" POSITION="left" ID="ID_236527223" CREATED="1554682686490" MODIFIED="1554682689112">
<edge COLOR="#0000ff"/>
<node TEXT="dowload master binaries" ID="ID_994865113" CREATED="1554682790676" MODIFIED="1554682801152"/>
<node TEXT="install master binaries" ID="ID_1280709774" CREATED="1554682801622" MODIFIED="1554682812493"/>
<node TEXT="config etcd" ID="ID_1249797274" CREATED="1554683174791" MODIFIED="1554683178564"/>
<node TEXT="config daemons" ID="ID_184994746" CREATED="1554683439994" MODIFIED="1554683559251">
<node TEXT="kube-apiserver" ID="ID_219427675" CREATED="1554683455267" MODIFIED="1554683645880">
<node TEXT="systemd unit" ID="ID_1999367965" CREATED="1554683765054" MODIFIED="1554683773453"/>
<node TEXT="encryption-config.yaml" ID="ID_543893331" CREATED="1554683774499" MODIFIED="1554683787594"/>
</node>
<node TEXT="kube-controller-manager" ID="ID_645274481" CREATED="1554683459892" MODIFIED="1554683659640">
<node TEXT="systemd unit" ID="ID_1018471410" CREATED="1554683795665" MODIFIED="1554683801208"/>
</node>
<node TEXT="kube-scheduler" ID="ID_481411441" CREATED="1554683465734" MODIFIED="1554683673884">
<node TEXT="systemd unit" ID="ID_635848407" CREATED="1554683804318" MODIFIED="1554683807750"/>
</node>
</node>
<node TEXT="start daemons" ID="ID_1802131550" CREATED="1554683840949" MODIFIED="1554683846371">
<node TEXT="etcd" ID="ID_587408796" CREATED="1554683848088" MODIFIED="1554683857622"/>
<node TEXT="nptd" ID="ID_1350380164" CREATED="1554683857881" MODIFIED="1554683859864"/>
<node TEXT="kube-apiserver" ID="ID_151468211" CREATED="1554683860147" MODIFIED="1554683866679"/>
<node TEXT="kube-controller-manager" ID="ID_1779705684" CREATED="1554683867194" MODIFIED="1554683874072"/>
<node TEXT="kube-scheduler" ID="ID_1786928119" CREATED="1554683874338" MODIFIED="1554683878883"/>
</node>
<node TEXT="cluster setup" ID="ID_957643790" CREATED="1554683912456" MODIFIED="1554683921246">
<node TEXT="RBAC &amp; ClusterRoleBinding" ID="ID_87787905" CREATED="1554683922779" MODIFIED="1554683944567"/>
<node TEXT="load ca certificates as secret" ID="ID_796195913" CREATED="1554683945452" MODIFIED="1554683964052"/>
<node TEXT="setup calico networking" ID="ID_277637370" CREATED="1554683964590" MODIFIED="1554683976247"/>
<node TEXT="setup kube-dns" ID="ID_1533368033" CREATED="1554683976668" MODIFIED="1554683984510"/>
</node>
</node>
</node>
</map>
