package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// VisitorsAppSpec defines the desired state of VisitorsApp
type VisitorsAppSpec struct {
	Size  int32  `json:"size"`
	Title string `json:"title"`
}

// VisitorsAppStatus defines the observed state of VisitorsApp
type VisitorsAppStatus struct {
	BackendImage  string `json:"backendImage"`
	FrontendImage string `json:"frontendImage"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// VisitorsApp is the Schema for the visitorsapps API
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=visitorsapps,scope=Namespaced
type VisitorsApp struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   VisitorsAppSpec   `json:"spec,omitempty"`
	Status VisitorsAppStatus `json:"status,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// VisitorsAppList contains a list of VisitorsApp
type VisitorsAppList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []VisitorsApp `json:"items"`
}

func init() {
	SchemeBuilder.Register(&VisitorsApp{}, &VisitorsAppList{})
}
