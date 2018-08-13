using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDetector : MonoBehaviour {

	private float rayAngle = 4;
	private float rayDistance = 170;
	private string playerObjectName = "Player";

	void FixedUpdate() {
		for (int i = -1; i < 2; i++) {
			Vector2 rayDirection = Quaternion.AngleAxis (i * rayAngle, Vector3.forward) * transform.up;
			RaycastHit2D hit = Physics2D.Raycast (transform.position, rayDirection, rayDistance);

			if (hit.collider != null) {
				Debug.DrawRay (transform.position, hit.point - new Vector2 (transform.position.x, transform.position.y), Color.green);	
				if (hit.collider.gameObject.name == playerObjectName) {
					Debug.Log ("Player detected!");
				}
			} else {
				Debug.DrawRay (transform.position, rayDirection * rayDistance, Color.red);	
			}
		}
	}
}