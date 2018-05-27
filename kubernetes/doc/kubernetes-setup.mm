<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="kubernetes setup" FOLDED="false" ID="ID_1803439569" CREATED="1527397840108" MODIFIED="1527397862512" STYLE="oval">
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
<node TEXT="etcd" POSITION="right" ID="ID_119159163" CREATED="1527397863330" MODIFIED="1527397874147">
<edge COLOR="#ff0000"/>
</node>
<node TEXT="hard way" POSITION="left" ID="ID_1873302835" CREATED="1527397882074" MODIFIED="1527397894547">
<edge COLOR="#00ff00"/>
<node TEXT="etcd" ID="ID_245425366" CREATED="1527397895025" MODIFIED="1527397898003"/>
<node TEXT="control plane" ID="ID_1016884169" CREATED="1527397901050" MODIFIED="1527397930193">
<node TEXT="install" ID="ID_1959489289" CREATED="1527398495343" MODIFIED="1527398503009"/>
<node TEXT="config" ID="ID_531028872" CREATED="1527398503543" MODIFIED="1527398506377">
<node TEXT="kube-controller-manager" ID="ID_978172514" CREATED="1527397985070" MODIFIED="1527397992249"/>
<node TEXT="kube-scheduler" ID="ID_781830721" CREATED="1527397977454" MODIFIED="1527397984288"/>
<node TEXT="kube-apiserver" ID="ID_128743502" CREATED="1527397967175" MODIFIED="1527397976792"/>
</node>
</node>
<node TEXT="worker" ID="ID_1074448482" CREATED="1527397930848" MODIFIED="1527397932626">
<node TEXT="kubelet" ID="ID_1912328661" CREATED="1527397999558" MODIFIED="1527398002799"/>
<node TEXT="kube-proxy" ID="ID_499916774" CREATED="1527398003574" MODIFIED="1527398008215"/>
<node TEXT="containerd" ID="ID_931303747" CREATED="1527398088372" MODIFIED="1527398092405"/>
<node TEXT="download kubernetes binaries" ID="ID_1884589820" CREATED="1527398281651" MODIFIED="1527398306187">
<node TEXT="kubectl" ID="ID_1472668123" CREATED="1527398307386" MODIFIED="1527398311371"/>
<node TEXT="kubelet" ID="ID_568098162" CREATED="1527398311970" MODIFIED="1527398315651"/>
<node TEXT="kube-proxy" ID="ID_271052758" CREATED="1527398316057" MODIFIED="1527398410308"/>
<node TEXT="critctl" ID="ID_1472212867" CREATED="1527398412234" MODIFIED="1527398420187"/>
<node TEXT="runc" ID="ID_1536229342" CREATED="1527398420723" MODIFIED="1527398423347"/>
<node TEXT="runsc" ID="ID_626390665" CREATED="1527398424042" MODIFIED="1527398426851"/>
<node TEXT="cni-plugins" ID="ID_808608330" CREATED="1527398431353" MODIFIED="1527398438739"/>
<node TEXT="containerd" ID="ID_257526502" CREATED="1527398439329" MODIFIED="1527398441843"/>
</node>
</node>
<node TEXT="meta images(k8s.gcr.io)" ID="ID_190658304" CREATED="1527398025533" MODIFIED="1527398057446">
<node TEXT="pull-retag-save" ID="ID_898102562" CREATED="1527398033949" MODIFIED="1527398080485"/>
<node TEXT="load" ID="ID_1888475243" CREATED="1527398081684" MODIFIED="1527398085678"/>
</node>
<node TEXT="certificates" ID="ID_176797737" CREATED="1527398149854" MODIFIED="1527398155528">
<node TEXT="ca" ID="ID_1030481972" CREATED="1527399992937" MODIFIED="1527406426591"/>
<node TEXT="kube-apiserver" ID="ID_1712027642" CREATED="1527400019080" MODIFIED="1527406434487"/>
<node TEXT="kube-controller-manager" ID="ID_562682975" CREATED="1527406436180" MODIFIED="1527406442119"/>
<node TEXT="kube-proxy" ID="ID_759989533" CREATED="1527406442620" MODIFIED="1527406446031"/>
<node TEXT="kube-scheduler" ID="ID_1120608617" CREATED="1527406447244" MODIFIED="1527406454359"/>
<node TEXT="service-account" ID="ID_110582273" CREATED="1527406455052" MODIFIED="1527406461326"/>
<node TEXT="kubelet for each worker" ID="ID_309036958" CREATED="1527406461692" MODIFIED="1527406486444"/>
<node TEXT="admin" ID="ID_1947725756" CREATED="1527406365588" MODIFIED="1527406370617"/>
</node>
<node TEXT="kubeconfig" ID="ID_493012083" CREATED="1527406527904" MODIFIED="1527406530498">
<node TEXT="worker" ID="ID_563318440" CREATED="1527406531279" MODIFIED="1527406540673"/>
<node TEXT="admin" ID="ID_632327238" CREATED="1527406541343" MODIFIED="1527406542832"/>
</node>
<node TEXT="os base config" ID="ID_126305237" CREATED="1527398180510" MODIFIED="1527398192343">
<node TEXT="hostname" ID="ID_796672757" CREATED="1527398192797" MODIFIED="1527398196735"/>
<node TEXT="disable swap" ID="ID_1789008573" CREATED="1527398197389" MODIFIED="1527398203366"/>
<node TEXT="disable firewall" ID="ID_1088462930" CREATED="1527398248405" MODIFIED="1527398253669"/>
<node TEXT="disable selinux" ID="ID_1041870061" CREATED="1527398262997" MODIFIED="1527398268653"/>
<node TEXT="enable IP forward" ID="ID_1184409491" CREATED="1527398203973" MODIFIED="1527398212998"/>
<node TEXT="time sync" ID="ID_51113815" CREATED="1527398224389" MODIFIED="1527398233246"/>
</node>
</node>
</node>
</map>
